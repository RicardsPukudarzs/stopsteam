class SessionsController < ApplicationController
  before_action :require_logged_out, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:user][:email])
    if user&.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'Logged in successfully.'
    else
      flash.now[:alert] = 'Invalid email or password.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:spotify_auth] = nil
    redirect_to root_path, notice: 'Logged out successfully.'
  end
end
