# encoding: utf-8

class ImportFileUploader < CarrierWave::Uploader::Base
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :contacts, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :personas
    def full_filename (for_file = model.import_file.file)
      "contacts.csv"
    end
  end

  version :time_slots, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :horarios
    def full_filename (for_file = model.import_file.file)
      "time_slots.csv"
    end
  end

  version :attendances, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :asistencias
    def full_filename (for_file = model.import_file.file)
      "attendances.csv"
    end
  end
  
  version :trial_lessons, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :pruebas
    def full_filename (for_file = model.import_file.file)
      "trial_lessons.csv"
    end
  end

  version :products, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :productos
    def full_filename (for_file = model.import_file.file)
      "products.csv"
    end
  end

  version :sales, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :ventas
    def full_filename (for_file = model.import_file.file)
      "sales.csv"
    end
  end

  version :memberships, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :plans
    def full_filename (for_file = model.import_file.file)
      "memberships.csv"
    end
  end

  version :installments, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :tickets
    def full_filename (for_file = model.import_file.file)
      "installments.csv"
    end
  end
  
  version :comments, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :follow_ups
    def full_filename (for_file = model.import_file.file)
      "comments.csv"
    end
  end
  
  version :communications, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :contacts
    def full_filename (for_file = model.import_file.file)
      "communications.csv"
    end
  end
  
  version :drop_outs, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :evasions
    def full_filename (for_file = model.import_file.file)
      "drop_outs.csv"
    end
  end

  version :enrollments, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :matriculas
    def full_filename (for_file = model.import_file.file)
      "enrollments.csv"
    end
  end

  version :follows, :if => :is_kshema? do
    process :extract_file_from_kshema_zip => :instructors
    def full_filename (for_file = model.import_file.file)
      "follows.csv"
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

  protected
   def is_kshema? file
    model.source_system == 'kshema'
   end
end
