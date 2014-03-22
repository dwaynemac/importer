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

  ## SYS versions

  def extract_file(filename)
    file = nil
    case model.source_system
      when 'kshema'
        file = extract_file_from_kshema_zip filename
      when 'sys'
        if [:personas].include? filename
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
    headers = %w(NumeroCliente Apelido BairroRes BairroCom Cargo Categoria CEP CEPCom Cidade CidadeCom 
      Email Empresa EndResidencial EndProfissional EndComplRes EndComplCom NumRes NumCom 
      Estado EstadoCom EstadoCivil Grau IndicadoPor Livros_que_leu Nascimento Nome Perfil
      Profissao Observacoes sexo Telefone2 TelefoneRes TelefoneCom)
    
    
    CSV.open("tmp/contacts.csv","w") do |csv|
      csv << headers
      CSV.foreach(current_path, col_sep: ";", encoding: "UTF-8", headers: :first_row) do |row|
        current_row = []
        headers.each do |h|
          current_row << get_value_for(h, row, headers)
        end
        csv << current_row
      end
    end
    File.open("tmp/contacts.csv","r")
  end

  protected

   def get_value_for(field, row, headers)
      headers.index(field).nil? ? nil : row[headers.index(field)]
    end
end
