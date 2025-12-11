class SpotifyController < ApplicationController
  before_action :require_logged_in

  def spotify
    session[:spotify_auth] = request.env['omniauth.auth']
    spotify_user_data = RSpotify::User.new(session[:spotify_auth])
    if SpotifyUser.exists?(spotify_id: spotify_user_data.id)
      flash[:alert] = 'This Spotify account is already linked to another user.'
      redirect_to dashboard_path
      return
    end

    service = SpotifyService.new(session[:spotify_auth], current_user)
    service.sync_user

    flash[:notice] = 'Spotify account linked successfully.'
    redirect_to dashboard_path
  end
end
