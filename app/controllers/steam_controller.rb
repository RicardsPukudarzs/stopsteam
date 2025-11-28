class SteamController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:steam]

  def steam
    auth = request.env['omniauth.auth']
    steam_id = auth.uid

    service = SteamService.new
    service.sync_data(current_user, steam_id)

    redirect_to dashboard_path
  end

  def show
  end

  def steam_test
    steam_api = SteamApi.new
    test = steam_api.game_info(730)
    render json: test
  end
end
