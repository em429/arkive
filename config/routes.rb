Rails.application.routes.draw do
  root 'webpages#index'

  resources :users do
    resources :webpages
  end

  resources :webpage_statuses, only: [ :update ]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :webpages, only: [ :create ]
    end
  end

  resource :session, only: [ :new, :create, :destroy ]
 
  # Custom routes - must map to an existing canonical resource URL
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
end
