Rails.application.routes.draw do
  root 'webpages#index'

  resources :users
  resources :webpages do
    get 'toggle_read_status', on: :member
    get 'show_read', on: :collection
  end
  
  get '/signup', to: 'users#new'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # API
  namespace :api do
    namespace :v1 do
      resources :webpages, only: :create
    end
  end
end
