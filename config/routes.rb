Importer::Application.routes.draw do
  devise_for :users

  resources :imports
  root to: 'imports#index'
  get 'home' => 'home#show'
end
