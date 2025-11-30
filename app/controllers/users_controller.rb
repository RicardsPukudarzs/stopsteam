class UsersController < ApplicationController
  before_action :require_logged_out, only: %i[new create]
  before_action :require_logged_in, only: %i[show update disconnect_steam disconnect_spotify destroy_account]

  def show; end

  def new; end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to login_path, notice: 'Registered successfully.'
    else
      flash.now[:alert] = 'Registration failed. Please check the errors below.'
      render :new
    end
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path, notice: 'Profile updated successfully.'
    else
      flash.now[:alert] = 'Update failed. Please check the errors below.'
      render :show
    end
  end

  def disconnect_steam
    current_user.steam_user&.destroy
    redirect_to user_path, notice: 'Steam disconnected.'
  end

  def disconnect_spotify
    current_user.spotify_user&.destroy
    redirect_to user_path, notice: 'Spotify disconnected.'
  end

  def destroy_account
    current_user.destroy
    reset_session
    redirect_to root_path, notice: 'Account deleted.'
  end

  private

  def user_params
    params.expect(user: %i[username email password password_confirmation])
  end
end
