if Rails.env.development?# || Rails.env.test?
  CONFIG = YAML.load_file("#{Rails.root}/config/environment_variables.yml")
else
  CONFIG = {}
  CONFIG['devise_secret_key'] = 'asdf'
end
