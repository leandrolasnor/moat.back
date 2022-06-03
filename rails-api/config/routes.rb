require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => "/cable"
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post  '/albums', to: 'albums#index'
  # get   '/albums/:id', to: 'albums#show'
  resources :albums, id: /[a-z0-9\-_]+/, only: [:show]
  match "*path" => "application#not_found", via: :all
end
