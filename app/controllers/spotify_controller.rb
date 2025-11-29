class SpotifyController < ApplicationController
  before_action :require_logged_in

  def spotify
    session[:spotify_auth] = request.env['omniauth.auth']
    service = SpotifyService.new(session[:spotify_auth], current_user)
    service.sync_user

    redirect_to dashboard_path
  end
end
