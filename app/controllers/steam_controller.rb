class SteamController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:steam]

  def steam
    auth = request.env['omniauth.auth']
    steam_id = auth.uid
    steam = SteamApi.new
    player_info = steam.player_summary(steam_id)
    steam_user = player_info['response']['players'][0]
    steam_user_record =
      (current_user.steam_user || current_user.build_steam_user).tap do |su|
        su.update(
          steam_id: steam_user['steamid'],
          name: steam_user['personaname'],
          profile_image_url: steam_user['avatarfull'],
          profile_url: steam_user['profileurl'],
          user_id: current_user.id
        )
      end
    save_user_games(steam_id, steam_user_record)
    redirect_to dashboard_path
  end

  def save_user_games(steam_id, steam_user_record)
    steam = SteamApi.new
    games_info = steam.owned_games(steam_id)
    games = games_info['response']['games']

    steam_user_record.user_game.delete_all

    games.each do |game|
      steam_user_record.user_game.create!(
        app_id: game['appid'],
        name: game['name'],
        playtime_forever: game['playtime_forever'],
        img_icon_url: game['img_icon_url'],
        rtime_last_played: game['rtime_last_played']
      )
    end
  end
end
