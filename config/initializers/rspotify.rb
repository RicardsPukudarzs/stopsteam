if Rails.env.production? || Rails.env.development?
  RSpotify.authenticate(
    ENV.fetch('CLIENT_ID', 'dummy'),
    ENV.fetch('CLIENT_SECRET', 'dummy')
  )
end
