Importer::Application.routes.draw do
  devise_for :users
  devise_scope :users do
    get "/login", :to => "devise/cas_sessions#new"
    post '/logout', to: "devise/cas_sessions#destroy"
  end

  resources :imports
  resources :import_modules do
    member do
      get :failed_rows
    end
  end
  root to: 'imports#index'
  get 'home' => 'home#show'
end
