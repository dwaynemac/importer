Importer::Application.routes.draw do
  get "import_modules/failed_rows"
  devise_for :users
  devise_scope :users do
    get "/login", :to => "devise/cas_sessions#new"
    post '/logout', to: "devise/cas_sessions#destroy"
  end

  resources :imports
  root to: 'imports#index'
  get 'home' => 'home#show'
end
