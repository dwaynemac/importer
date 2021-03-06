Importer::Application.routes.draw do
  devise_for :users
  devise_scope :users do
    get "/login", :to => "devise/cas_sessions#new"
    post '/logout', to: "devise/cas_sessions#destroy"
  end

  resources :imports do
    member do
      delete :rollback
    end
  end
  resources :import_modules do
    member do
      get :failed_rows
      get :failed_files
    end
  end
  root to: 'imports#index'
  get 'home' => 'home#show'
end
