# config/initializers/omniauth.rb

require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV.fetch('CLIENT_ID', nil), ENV.fetch('CLIENT_SECRET', nil),
           scope: 'user-read-email playlist-modify-public user-library-read user-library-modify user-top-read'

  provider :steam, ENV.fetch('STEAM_API_KEY', nil), {
    provider_ignores_state: true
  }
end

OmniAuth.config.allowed_request_methods = %i[post get]
