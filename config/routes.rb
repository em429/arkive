Rails.application.routes.draw do
  root 'webpages#index'

  # Automagically creates CRUD routes
  resources :webpages

  get "/webpages/:id/toggle_read_status", to: "webpages#toggle_read_status", as: "toggle_read_status"
  get "/show_read", to: "webpages#show_read", as: "show_read"
end
