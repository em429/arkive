Rails.application.routes.draw do
  get 'sessions/new'

  resources :users
  resources :webpages

  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root 'webpages#index'

  get '/webpages/:id/toggle_read_status', to: 'webpages#toggle_read_status', as: 'toggle_read_status'
  get '/show_read', to: 'webpages#show_read', as: 'show_read'

  # API
  namespace :api do
    namespace :v1 do
      resources :webpages, only: :create
    end
  end
end
