class UsersController < ApplicationController
  before_action :require_logged_out, only: %i[new create]
  before_action :require_logged_in, only: %i[show update disconnect_steam disconnect_spotify destroy_account]

  def show; end

  def new; end

  def create
    required_fields = %i[username email password password_confirmation]
    if required_fields.any? { |field| user_params[field].blank? }
      redirect_to register_path, alert: 'All fields must be filled.'
      return
    end

    if user_params[:username].length <= 3
      redirect_to register_path, alert: 'Username must be longer than 3 characters.'
      return
    end

    if User.exists?(email: user_params[:email])
      redirect_to register_path, alert: 'Email is already taken.'
      return
    end

    if user_params[:password].length < 6
      redirect_to register_path, alert: 'Password must be at least 6 characters long.'
      return
    end

    if user_params[:password] != user_params[:password_confirmation]
      redirect_to register_path, alert: 'Password and password confirmation must match.'
      return
    end

    user = User.new(user_params)
    if user.save
      redirect_to login_path, notice: 'Registered successfully.'
    else
      redirect_to register_path, alert: 'Registration failed, something went wrong.'
    end
  end

  def update
    required_fields = %i[username email password password_confirmation]
    if required_fields.any? { |field| user_params[field].blank? }
      redirect_to profile_path, alert: 'All fields must be filled.'
      return
    end

    if user_params[:username].length <= 3
      redirect_to profile_path, alert: 'Username must be longer than 3 characters.'
      return
    end

    if User.where(email: user_params[:email]).where.not(id: current_user.id).exists?
      redirect_to profile_path, alert: 'Email is already taken.'
      return
    end

    if user_params[:password].length < 6
      redirect_to profile_path, alert: 'Password must be at least 6 characters long.'
      return
    end

    if user_params[:password] != user_params[:password_confirmation]
      redirect_to profile_path, alert: 'Password and password confirmation must match.'
      return
    end

    if current_user.update(user_params)
      redirect_to profile_path, notice: 'Profile edited successfully.'
    else
      redirect_to profile_path, alert: 'Failed to edit profile, something went wrong.'
    end
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

  private

  def user_params
    params.expect(user: %i[username email password password_confirmation])
  end
end
