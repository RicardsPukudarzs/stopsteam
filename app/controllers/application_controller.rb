class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_logged_out
    redirect_to dashboard_path if logged_in?
  end

  def require_logged_in
    redirect_to login_path unless logged_in?
  end

  def route_not_found
    if logged_in?
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end
end
