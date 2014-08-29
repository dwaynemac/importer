# encoding: utf-8
require 'csv'

class ImportFileUploader < CarrierWave::Uploader::Base
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  ## Kshêma versions

  version :contacts do
    process :extract_file => :personas
    def full_filename (for_file = model.import_file.file)
      "contacts.csv"
    end
  end

  version :time_slots do
    process :extract_file => :horarios
    def full_filename (for_file = model.import_file.file)
      "time_slots.csv"
    end
  end

  version :attendances do
    process :extract_file => :asistencias
    def full_filename (for_file = model.import_file.file)
      "attendances.csv"
    end
  end
  
  version :trial_lessons do
    process :extract_file => :pruebas
    def full_filename (for_file = model.import_file.file)
      "trial_lessons.csv"
    end
  end

  version :products do
    process :extract_file => :productos
    def full_filename (for_file = model.import_file.file)
      "products.csv"
    end
  end

  version :sales do
    process :extract_file => :ventas
    def full_filename (for_file = model.import_file.file)
      "sales.csv"
    end
  end

  version :memberships do
    process :extract_file => :plans
    def full_filename (for_file = model.import_file.file)
      "memberships.csv"
    end
  end

  version :installments do
    process :extract_file => :tickets
    def full_filename (for_file = model.import_file.file)
      "installments.csv"
    end
  end
  
  version :comments do
    process :extract_file => :follow_ups
    def full_filename (for_file = model.import_file.file)
      "comments.csv"
    end
  end
  
  version :communications do
    process :extract_file => :contacts
    def full_filename (for_file = model.import_file.file)
      "communications.csv"
    end
  end
  
  version :drop_outs do
    process :extract_file => :evasions
    def full_filename (for_file = model.import_file.file)
      "drop_outs.csv"
    end
  end

  version :enrollments do
    process :extract_file => :matriculas
    def full_filename (for_file = model.import_file.file)
      "enrollments.csv"
    end
  end

  version :follows do
    process :extract_file => :instructors
    def full_filename (for_file = model.import_file.file)
      "follows.csv"
    end
  end

  version :mailing do
    process :extract_file => :mail_models
    def full_filename (for_file = model.import_file.file)
      "mailing.csv"
    end
  end

  ## SYS versions

  def extract_file(filename)
    file = nil
    case model.source_system
      when 'kshema'
        file = extract_file_from_kshema_zip filename
      when 'sys'
        if [:personas, :contacts, :evasions, :matriculas, :horarios].include? filename
          file = extract_file_from_sys_csv filename 
        end
    end
  end

  def extract_file_from_kshema_zip(filename)
    file = nil
    Zip::ZipFile.open(current_path) do |zip_file|
      file = zip_file.select{|f| f.name.match(/.*#{filename}/)}.first
      zip_file.extract(file, "tmp/" + file.name.gsub("/", "-")){ true }
    end
    File.delete(current_path)
    FileUtils.cp("tmp/" + file.name.gsub("/", "-"), current_path)
  end

  def extract_file_from_sys_csv(model_name)
    file = send("generate_sys_#{model_name}_file")
    File.delete(current_path)
    FileUtils.cp(file.path, current_path)
  end

  def generate_sys_personas_file
    headers = %w(NumeroCliente Apelido BairroRes BairroCom Cargo Categoria CEP Cidade 
      Email Empresa EndResidencial Estado EstadoCivil Grau IndicadoPor Livros_que_leu Nascimento Nome 
      Profissao Observacoes sexo Telefone2 TelefoneRes TelefoneCom Ja_praticou Ja_similar DataGrad)
    padma_headers = %w(id apelido state commercial_address cargo coeficiente_id codigo_postal city mail 
      company dire state civil_state grado_id indicado_por livros_que_leu fecha_nacimiento nombres 
      apellidos profesion notes genero tel other_tel tel_com ja_practicou ja_similar data_grad) 
    
    # TODO change values like sexo to match padma values
    CSV.open("tmp/contacts.csv","w") do |csv|
      csv << padma_headers
      CSV.foreach(current_path, col_sep: ";", encoding: "UTF-8", headers: :first_row) do |row|
        current_row = []
        complete_headers = row.headers()
        headers.each do |h|
          value = get_value_for(h, row, complete_headers)
          case h
            when 'NumeroCliente'
              value = set_id_from_account(value, model.account.name)
            when 'EndResidencial'
              value = generate_address(
                value, get_value_for('NumRes', row, complete_headers),
                get_value_for('EndComplRes', row, complete_headers)
                )
            when 'BairroCom'
              value = generate_commercial_address(
                value, 
                get_value_for('CEPCom', row, complete_headers),
                get_value_for('CidadeCom', row, headers),
                get_value_for('EndProfissional', row, complete_headers),
                get_value_for('EndComplCom', row, complete_headers),
                get_value_for('NumCom', row, complete_headers),
                get_value_for('EstadoCom', row, complete_headers)
                )
            when 'Categoria'
              value = get_valid_contacts_coefficient(value, get_value_for('Perfil',row, complete_headers))
            when 'Grau'
              value = get_valid_contacts_level(value)
            when 'Nome'
              names = set_name_and_last_name(value)
              current_row << names[:nombres]
              value = names[:apellidos]
            when 'sexo'
              value = get_valid_contacts_gender(value)
          end

          current_row << value
        end
        csv << current_row
      end
    end
    File.open("tmp/contacts.csv","r")
  end

  def generate_sys_contacts_file
    headers = %w(NumeroCliente DataTelefone DataVisita DataEmail Motivo)
    padma_headers = %w(persona_id type contact_type fecha observations instructor_id coeficiente_id)
    admin_user = get_director_username()

    CSV.open("tmp/communications.csv","w") do |csv|
      csv << padma_headers
      CSV.foreach(current_path, col_sep: ";", encoding: "UTF-8", headers: :first_row) do |row|
        complete_headers = row.headers()
        id = set_id_from_account(get_value_for('NumeroCliente', row, complete_headers), model.account.name)
        observations = get_value_for('Motivo', row, complete_headers)
        
        tel_data = get_value_for('DataTelefone', row, complete_headers)
        visit_data = get_value_for('DataVisita', row, complete_headers)
        email_data = get_value_for('DataEmail', row, complete_headers)
        coefficient = ( is_perfil?(get_value_for('Perfil', row, complete_headers)) ? 'perfil' : 'fp')
        
        %w(DataTelefone DataVisita DataEmail).each do |comm_data|
          communication_date = get_value_for(comm_data, row, complete_headers)
          if !communication_date.blank? && has_communication_date?(communication_date)
            type = get_communication_type(comm_data)
            current_row = [id, type[:communication], type[:communication_data], communication_date, observations, admin_user, coefficient]
            csv << current_row
          end
        end
      end
    end
    File.open("tmp/communications.csv","r")
  end

  def generate_sys_evasions_file
    headers = %w(NumeroCliente Motivo Grau)
    padma_headers = %w(fecha persona_id notas grado_id instructor_id)
    admin_user = get_director_username()

    CSV.open("tmp/drop_outs.csv","w") do |csv|
      csv << padma_headers
      CSV.foreach(current_path, col_sep: ";", encoding: "UTF-8", headers: :first_row) do |row|
        complete_headers = row.headers()
        dropOutDate = get_value_for('DataSaida', row, complete_headers)
        if has_communication_date?(dropOutDate)
          current_row = []
          current_row << dropOutDate
          headers.each do |h|
            value = get_value_for(h, row, complete_headers)
            case h
              when 'NumeroCliente'
                current_row << set_id_from_account(value, model.account.name)
              when 'Grau'
                current_row << get_valid_contacts_level(value)
              else
                current_row << value
            end
            current_row << admin_user
          end
          csv << current_row
        end
      end
    end
    File.open("tmp/drop_outs.csv","r")
  end

  def generate_sys_matriculas_file
    headers = %w(NumeroCliente DataMatricula)
    padma_headers = %w(persona_id fecha instructor_id)
    admin_user = get_director_username()

    CSV.open("tmp/enrollments.csv","w") do |csv|
      csv << padma_headers
      CSV.foreach(current_path, col_sep: ";", encoding: "UTF-8", headers: :first_row) do |row|
        complete_headers = row.headers()
        enrollmentDate = get_value_for('DataMatricula', row, complete_headers)
        if has_communication_date?(enrollmentDate)
          current_row = []
          headers.each do |h|
            value = get_value_for(h, row, complete_headers)
            case h
            when 'NumeroCliente'
              current_row << set_id_from_account(value, model.account.name)
            else
              current_row << value
            end
          end
          current_row << admin_user
          csv << current_row
        end
      end
    end
    File.open("tmp/enrollments.csv","r")
  end

  def generate_sys_horarios_file
    headers = %w(Turma Yoga_Bio)
    CSV.open("tmp/time_slots.csv","w") do |csv|
      csv << headers
      CSV.foreach(current_path, col_sep: ";", encoding: "UTF-8", headers: :first_row) do |row|
        complete_headers = row.headers()
        current_row = []
        headers.each do |h|
          current_row << get_value_for(h, row, complete_headers)
        end
        csv << current_row
      end
    end
    File.open("tmp/time_slots.csv","r")
  end

  protected

   def set_id_from_account(id, account_name)
    return account_name+id
   end

   def get_value_for(field, row, complete_headers)
      response = complete_headers.index(field).nil? ? nil : row[complete_headers.index(field)]
      clean_value(response)
   end

   def generate_commercial_address(barrio, cep, city, address, com_number, number, state)
    response = [barrio, cep, city, address, com_number, number, state].reject!(&:blank?)
    if !response.nil?
      response = response.join(',')
    end
    return response
   end

   def generate_address(address, number, end_compl_res)
    response = address.to_s
    response << "num: #{number}" unless number.blank?
    response << "end_compl_res: #{end_compl_res}" unless end_compl_res.blank?      

    return response
   end

   def set_name_and_last_name(value)
      name = value.split.first
      last_name = value.split[1..10].join(" ")
     {:nombres => name, :apellidos => last_name}
   end

   def get_valid_contacts_gender(value) 
     if %w(fem a).include? value
      return 'female'
    elsif %w(mas o)
      return 'male'
    else
      return nil
    end
   end

   def get_valid_contacts_level(value)
     case value.try :downcase
      when 'aspirante'
        return 'aspirante'
      when'assistente'
        return 'asistente'
      when 'chêla'
        return 'chêla'
      when 'graduado'
        return 'graduado'
      when 'NULL'
        return ''
      when 'sádhaka'
        return 'sádhaka'
      when 'yôgin'
        return 'yôgin'
     end
   end

   def get_valid_contacts_coefficient(status, coefficient)
    case status.try :downcase
      when 'aluno'
        return 'alumno'
      when 'ex-aluno'
        if is_perfil?(coefficient)
          return 'exalumno'
        else
          return 'exalumnofp'
        end
      when 'visita'
        if is_perfil?(coefficient)
          return 'perfil'
        else
          return 'fp'
        end
      when 'telefone'
        return 'unknown'
      when 'site'
        return 'unknown'
      when 'equipe'
        return 'unknown'
      when 'fest-Yôga'
        return 'unknown'
      when 'profissional'
        return 'unknown'
      else
        return 'unknown'
    end
   end

   def is_perfil?(value)
     return %w(s sim S NULL Sim).include? value || value.blank?
   end

   def clean_value(value)
    return (value == 'NULL' ? '' : value)
   end

   def get_communication_type(communication_data)
    response = {communication: nil, communication_data: nil}
     case communication_data
       when 'DataTelefone'
        response[:communication] = 'Televisita'
        response[:communication_data] = 't'
       when 'DataVisita'
        response[:communication] = 'Visita'
       when 'DataEmail'
        response[:communication] = 'Televisita'
     end
    return response
   end

   def has_communication_date?(communication_date)
    response = false
    begin
      DateTime.parse(communication_date)
      response = true
    rescue ArgumentError
    end
    response
   end

   def get_director_username
    response = nil
    # FIXME this should be the code, but now it is not working as expected
    # current_account = PadmaAccount.find(model.account.name)
    # users = current_account.users
    users = PadmaUser.all(per_page: 100)
    users.each do |user|
      roles = user.roles
      roles.each do |role|
        if role['name'] == 'director' && role['account_name'] == model.account.name 
          response = user.username
        end
      end
    end
    return response
   end
end
