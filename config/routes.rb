Rails.application.routes.draw do
  root 'events#index'
  resources :events do
    collection do
      get 'toggle_door'
      get 'status_door'
      get 'register_token'
    end
  end
end