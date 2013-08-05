if Rails.env == 'development'
  CONFIG = YAML.load_file("#{Rails.root}/config/environment_variables.yml")
else
  CONFIG = {}
end