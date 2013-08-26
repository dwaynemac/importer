Importer::Application.routes.draw do
  devise_for :users do
    get "/login", :to => "devise/cas_sessions#new"
    post '/logout', to: "devise/cas_sessions#destroy"
  end

  resources :imports
  root to: 'imports#index'
  get 'home' => 'home#show'
end
