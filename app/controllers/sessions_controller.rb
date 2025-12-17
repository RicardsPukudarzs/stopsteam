class SessionsController < ApplicationController
  before_action :require_logged_out, only: %i[new create]

  def new; end

  def create
    email = params[:user][:email]
    password = params[:user][:password]
    if email.blank? || password.blank?
      redirect_to login_path, alert: 'Email and password cannot be blank.'
      return
    end
    user = User.find_by(email: email)
    if user&.authenticate(password)
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'Logged in successfully.'
    else
      redirect_to login_path, alert: 'Wrong email or password'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:spotify_auth] = nil
    redirect_to root_path, notice: 'Logged out successfully.'
  end
end
