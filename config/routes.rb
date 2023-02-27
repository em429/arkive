Rails.application.routes.draw do
  root 'webpages#index'

  # Give /user/:user_id priority over the nested webpage resource,
  # so the guards don't fire when the id is a valid user.
  # This theoritically enables collision attacks on username and webpage md5_hash_ids;
  #   which is okay as we don't allow that long user ids.
  resources :users, path: 'user', only: [:show]

  # Again, give edit priority, so the WebpageController guards don't fire:
  resources :users, path: 'user', only: [:edit]
  
  resources :users, path: 'user' do
    # To get nice, simple /:user_id/:url_md5_hash routes for our webpages,
    # we use a scope with a shallow_path modifier:
    scope shallow_path: ":user_id" do
      # Because of the nested and empty path, there would be a route collision
      # by default on /user/:user_id.
      # 
      # To avoid this, we explicitly put :index and :create on /user/:user_id/webpages
      resources :webpages, path: 'webpages', param: :url_md5_hash, only: [:index, :create]
      
      # Then create the definition with the simplified, empty path
      resources :webpages,
                path: '',
                param: :url_md5_hash,
                shallow: true,
                # Rename the default /edit and /new paths to explicitly signal we are
                # operating on a webpage: (and to avoid potential route collisions)
                path_names: { edit: 'edit-webpage', new: 'new-webpage' },
                # Exclude index and create, as we defined them above
                only: [:show, :new, :edit, :update, :destroy]
    end
  end

  resource :session, only: [:new, :create, :destroy]
 
  get '/:user_id/:url_md5_hash/mark_read' => 'webpages#mark_read', as: 'mark_read'
  get '/:user_id/:url_md5_hash/mark_unread' => 'webpages#mark_unread', as: 'mark_unread'
  get '/:user_id/filter/:filter' => 'webpages#index', as: 'filtered_webpages'

  # Vanity URLs. Must map to an existing canonical resource URL
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
end
