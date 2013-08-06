Importer::Application.routes.draw do
  devise_for :users

  root to: 'application#home'
  get 'home' => 'home#show'
end
