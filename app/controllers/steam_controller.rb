class SteamController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:steam]
  before_action :require_logged_in

  def steam
    auth = request.env['omniauth.auth']
    steam_id = auth.uid

    service = SteamService.new
    service.sync_data(current_user, steam_id)

    redirect_to dashboard_path
  end
end
