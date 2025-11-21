require 'rspotify'

class SpotifyController < ApplicationController
  def spotify
    session[:spotify_auth] = request.env['omniauth.auth']
    redirect_to dashboard_path
  end
end
