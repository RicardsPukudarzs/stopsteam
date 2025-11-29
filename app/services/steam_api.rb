class SteamApi
  BASE_URL = 'https://api.steampowered.com'.freeze

  def initialize
    @api_key = ENV.fetch('STEAM_API_KEY', nil)
    @connection = Faraday.new(url: BASE_URL)
  end

  def player_summary(steam_id)
    get('/ISteamUser/GetPlayerSummaries/v0002/', steamids: steam_id)
  end

  def owned_games(steam_id)
    get('/IPlayerService/GetOwnedGames/v0001/',
        steamid: steam_id,
        include_appinfo: true,
        include_played_free_games: true)
  end

  def game_info(app_id, language = 'en')
    response = Faraday.get(
      'https://store.steampowered.com/api/appdetails',
      { appids: app_id, language: language }
    )
    return nil unless response.success?

    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("SteamApi#game_info error for app_id=#{app_id}: #{e.message}")
    nil
  end

  def user_level(steam_id)
    get('/IPlayerService/GetSteamLevel/v1/', steamid: steam_id)
  end

  def user_achievements(steam_id, app_id)
    get('/ISteamUserStats/GetPlayerAchievements/v0001/',
        steamid: steam_id,
        appid: app_id)
  end

  private

  def get(endpoint, params = {})
    response = @connection.get(endpoint, params.merge(key: @api_key))
    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("SteamApi#get error for #{endpoint}: #{e.message}")
    nil
  end
end
