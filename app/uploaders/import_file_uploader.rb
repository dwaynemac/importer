# encoding: utf-8

class ImportFileUploader < CarrierWave::Uploader::Base
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

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
      "contacts.csv"
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
      "enrollments.csv"
    end
  end

  def extract_file(filename)
    file = nil
    Zip::ZipFile.open(current_path) do |zip_file|
      file = zip_file.select{|f| f.name.match(/.*#{filename}/)}.first
      zip_file.extract(file, "tmp/" + file.name.gsub("/", "-")){ true }
    end
    File.delete(current_path)
    FileUtils.cp("tmp/" + file.name.gsub("/", "-"), current_path)
  end
end
