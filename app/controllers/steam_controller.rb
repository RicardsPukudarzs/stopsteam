class SteamController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:steam]

  def steam
    auth = request.env['omniauth.auth']
    steam_id = auth.uid

    service = SteamService.new
    service.sync_user(steam_id, current_user)

    redirect_to dashboard_path
  end
end
