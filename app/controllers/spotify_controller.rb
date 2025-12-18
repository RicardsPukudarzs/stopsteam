class SpotifyController < ApplicationController
  before_action :require_logged_in

  def spotify
    auth = request.env['omniauth.auth']
    spotify_user_data = RSpotify::User.new(auth)
    if SpotifyUser.where(spotify_id: spotify_user_data.id).where.not(user_id: current_user.id).exists?
      flash[:alert] = 'This Spotify account is already linked to another user.'
      redirect_to dashboard_path
      return
    end

    service = SpotifyService.new(auth, current_user)
    service.sync_user

    flash[:notice] = 'Spotify account linked successfully.'
    redirect_to dashboard_path
  end
end
