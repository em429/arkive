Rails.application.routes.draw do
  root 'webpages#index'

  # Automagically creates CRUD routes
  resources :webpages
end
