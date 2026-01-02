class FetchGameStatsJob < ApplicationJob
  # Nosaka darba izpildes rindu (queue)
  queue_as :default

  def perform(steam_user_id = nil)
    # Nosaka, vai statistika jāatjauno konkrētam Steam lietotājam vai visiem sistēmā esošajiem Steam lietotājiem
    steam_users = steam_user_id ? [SteamUser.find(steam_user_id)] : SteamUser.all

    # Iterē cauri katram Steam lietotājam
    steam_users.each do |steam_user|
      # Inicializē Steam API klientu
      steam_api = SteamApi.new
      # Iterē cauri visām lietotāja spēlēm izmantojot find_each
      steam_user.user_games.find_each do |user_game|
        # Iegūst lietotāja statistiku konkrētajai spēlei no Steam API
        stats_data = steam_api.user_stats_for_game(steam_user.steam_id, user_game.app_id)
        # Ja statistikas dati nav pieejami vai ir nepilnīgi, turpmākā apstrāde konkrētajai spēlei tiek izlaista
        next unless stats_data && stats_data['playerstats'] && stats_data['playerstats']['stats']

        # Apstrādā katru statistikas vienību atsevišķi
        stats_data['playerstats']['stats'].each do |stat|
          # Atrod vai izveido statistikas ierakstu datubāzē un atjaunina tā vērtību
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
