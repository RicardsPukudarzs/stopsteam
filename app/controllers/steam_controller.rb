class SteamController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:steam]
  before_action :require_logged_in

  def steam
    auth = request.env['omniauth.auth']
    steam_id = auth.uid

    if SteamUser.exists?(steam_id: steam_id)
      flash[:alert] = 'This Steam account is already linked to another user.'
      redirect_to dashboard_path
      return
    end

    service = SteamService.new
    service.sync_data(current_user, steam_id)

    flash[:notice] = 'Game stats will be available in a few minutes.'
    redirect_to dashboard_path
  end

  def test
    steam_api = SteamApi.new
    steam_id = '76561198211181033'
    data = steam_api.user_stats_for_game(steam_id, 960_090)
    render json: data
  end
end
