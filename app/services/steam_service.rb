class SteamService
  def initialize(steam_api = SteamApi.new)
    @steam_api = steam_api
  end

  def sync_user(steam_id, user)
    player_info = @steam_api.player_summary(steam_id)['response']['players'].first
    user_level = @steam_api.user_level(steam_id)['response']['player_level']

    steam_user = user.steam_user || user.build_steam_user
    steam_user.update(
      steam_id: player_info['steamid'],
      name: player_info['personaname'],
      profile_image_url: player_info['avatarfull'],
      profile_url: player_info['profileurl'],
      user_level: user_level,
      last_log_off: player_info['lastlogoff'],
      time_created: player_info['timecreated'],
      loc_country_code: player_info['loccountrycode'],
      user_id: user.id
    )

    sync_user_games(steam_id, steam_user)
    steam_user
  end

  def sync_user_games(steam_id, steam_user)
    games = @steam_api.owned_games(steam_id)['response']['games'] || []

    games.each do |game|
      steam_game = steam_user.user_game.find_or_initialize_by(app_id: game['appid'])
      steam_game.update(
        name: game['name'],
        playtime_forever: game['playtime_forever'],
        rtime_last_played: game['rtime_last_played'],
        img_icon_url: game['img_icon_url']
      )
    end
  end

  def achievement_count(steam_id, app_id)
    achievements = @steam_api.user_achievements(steam_id, app_id)
    return 0 unless achievements && achievements['playerstats']['achievements']

    achievements['playerstats']['achievements'].count { |a| a['achieved'] == 1 }
  end
end
