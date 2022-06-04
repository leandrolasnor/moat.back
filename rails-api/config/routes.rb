require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount_devise_token_auth_for 'User', at: 'auth'

  root to: ->(env) { [204, {}, ['']] }
  
  get  '/albums/search', to: 'albums#search'
  resources :albums, id: /[a-z0-9\-_]+/, only: [:show, :update, :destroy, :create]

  get '/artists', to: 'artists#list'
  match "*path" => "application#not_found", via: :all
end
