class ProfilesController < ApplicationController
  before_action :require_logged_in

  def show
  end

  def disconnect_steam
    current_user.steam_user&.destroy
    redirect_to profile_path, notice: 'Steam disconnected.'
  end

  def disconnect_spotify
    current_user.spotify_user&.destroy
    redirect_to profile_path, notice: 'Spotify disconnected.'
  end

  def destroy_account
    current_user.destroy
    reset_session
    redirect_to root_path, notice: 'Account deleted.'
  end
end
