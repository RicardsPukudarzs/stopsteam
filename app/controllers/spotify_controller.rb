require 'net/http'
require 'uri'
require 'json'

class SpotifyController < ApplicationController
  def auth
    redirect_to "https://accounts.spotify.com/authorize?client_id=#{ENV.fetch('CLIENT_ID', nil)}&response_type=code&redirect_uri=http://127.0.0.1:3000/spotify/callback&scope=user-read-email%20user-top-read",
                allow_other_host: true
  end

  def callback
    code = params[:code]
    uri = URI('https://accounts.spotify.com/api/token')
    res = Net::HTTP.post_form(uri, {
                                grant_type: 'authorization_code',
                                code: code,
                                redirect_uri: 'http://127.0.0.1:3000/spotify/callback',
                                client_id: ENV.fetch('CLIENT_ID', nil),
                                client_secret: ENV.fetch('CLIENT_SECRET', nil)
                              })
    token_data = JSON.parse(res.body)
    access_token = token_data['access_token']

    # Fetch user data
    user_info = fetch_spotify_users_artists(access_token)

    # Render or redirect with user_info
    render plain: user_info.to_json
  end

  private

  def fetch_spotify_user(access_token)
    uri = URI('https://api.spotify.com/v1/me')
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  end

  def fetch_spotify_users_artists(access_token, time_range: 'medium_term', limit: 20)
    uri = URI("https://api.spotify.com/v1/me/top/artists?time_range=#{time_range}&limit=#{limit}&offset=0")
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  end
end
