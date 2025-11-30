Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root to: redirect('/login')
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get 'up' => 'rails/health#show', as: :rails_health_check

  get '/logout', to: 'sessions#destroy'
  get '/dashboard', to: 'dashboards#index'

  get '/auth/spotify/callback', to: 'spotify#spotify'
  match '/auth/steam/callback', to: 'steam#steam', via: %i[get post]

  get '/search', to: 'search#index'

  get '/user/:id', to: 'user_comparison#show', as: :user_comparison
  get '/profile', to: 'users#show', as: :profile

  get '/game/:app_id', to: 'games#show', as: :game

  resource :user, only: %i[show update] do
    delete :disconnect_steam
    delete :disconnect_spotify
    delete :destroy_account
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
