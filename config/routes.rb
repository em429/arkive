Rails.application.routes.draw do
  root 'webpages#index'

  resources :users
  
  resources :webpages, param: :url_md5_hash
  get '/webpages/:url_md5_hash/mark_read' => 'webpages#mark_read', as: 'mark_read'
  get '/webpages/:url_md5_hash/mark_unread' => 'webpages#mark_unread', as: 'mark_unread'
  get '/webpages/filter/:filter' => 'webpages#index', as: 'filtered_webpages'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
end
