class FetchGameStatsJob < ApplicationJob
  queue_as :default

  def perform(steam_user_id = nil)
    steam_users = steam_user_id ? [SteamUser.find(steam_user_id)] : SteamUser.all

    steam_users.each do |steam_user|
      steam_api = SteamApi.new
      steam_user.user_games.find_each do |user_game|
        stats_data = steam_api.user_stats_for_game(steam_user.steam_id, user_game.app_id)
        next unless stats_data && stats_data['playerstats'] && stats_data['playerstats']['stats']

        stats_data['playerstats']['stats'].each do |stat|
          GameStat.find_or_create_by(
            steam_user: steam_user,
            app_id: user_game.app_id,
            stat_name: stat['name']
          ).update(stat_value: stat['value'])
        end
      end
    end
  end
end
