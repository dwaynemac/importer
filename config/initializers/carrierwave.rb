CarrierWave.configure do |config|
  # on development & testing, upload files to local `tmp` folder.
  if Rails.env.development? || Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider => 'AWS',
      :aws_access_key_id => ENV['S3_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET']
    }
    config.fog_directory = ENV['S3_BUCKET_NAME']
    config.cache_dir = "#{Rails.root}/tmp/uploads" # To let CarrierWave work on heroku
  end
end