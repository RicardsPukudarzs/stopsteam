# config/initializers/omniauth.rb

require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV.fetch('CLIENT_ID', nil), ENV.fetch('CLIENT_SECRET', nil),
           scope: 'user-read-email playlist-modify-public user-library-read user-library-modify user-top-read'
end

OmniAuth.config.allowed_request_methods = %i[post get]
