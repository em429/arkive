Rails.application.routes.draw do
  root 'webpages#index'

  resources :users do
    resources :webpages
  end

  resource :session, only: [ :new, :create, :destroy ]

  resources :webpage_statuses, only: [ :update ]
 
  # Vanity URLs. Must map to an existing canonical resource URL
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
end
