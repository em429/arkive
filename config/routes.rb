Rails.application.routes.draw do
  root 'webpages#index'

  resources :users
  resources :webpages, param: :url_md5_hash do
    get 'toggle_read_status', on: :member
  end
  
  get '/webpages/filter/:filter' => 'webpages#index', as: 'filtered_webpages'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
end
