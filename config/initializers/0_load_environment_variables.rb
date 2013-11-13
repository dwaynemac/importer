if Rails.env.development? || Rails.env.test?
  CONFIG = YAML.load_file("#{Rails.root}/config/environment_variables.yml")
else
  CONFIG = {}
end
