# encoding: utf-8

class ImportFileUploader < CarrierWave::Uploader::Base
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :contacts do
    process :extract_file => :contacts
    def full_filename (for_file = model.import_file.file)
      "contacts.csv"
    end
  end

  version :time_slots do
    process :extract_file => :belgrano_horarios
    def full_filename (for_file = model.import_file.file)
      "time_slots.csv"
    end
  end

  version :attendances do
    process :extract_file => :belgrano_asistencias
    def full_filename (for_file = model.import_file.file)
      "attendances.csv"
    end
  end
  
  version :trial_lessons do
    process :extract_file => :belgrano_pruebas
    def full_filename (for_file = model.import_file.file)
      "trail_lessons.csv"
    end
  end

  def extract_file(filename)
    file = nil
    Zip::ZipFile.open(current_path) do |zip_file|
      file = zip_file.select{|f| f.name.match(/#{filename}/)}.first
      zip_file.extract(file, "tmp/" + file.name.gsub("/", "-")){ true }
    end
    File.delete(current_path)
    FileUtils.cp("tmp/" + file.name.gsub("/", "-"), current_path)
  end
end
