class SessionsController < ApplicationController
  before_action :set_current_user

  def new
    @user = User.new
  end

  def create
    @user = User.new
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      Rails.logger.debug { "@current_user: #{@current_user.inspect}" }
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully.'
  end

  private

  def set_current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
