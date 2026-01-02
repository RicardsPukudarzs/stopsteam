class SteamApi
  # Steam API bāzes URL
  BASE_URL = 'https://api.steampowered.com'.freeze

  # Inicializē Steam API klientu
  def initialize
    @api_key = ENV.fetch('STEAM_API_KEY', nil)
    @connection = Faraday.new(url: BASE_URL)
  end

  # Iegūst lietotāju pamatinformāciju
  def player_summary(steam_id)
    get('/ISteamUser/GetPlayerSummaries/v0002/', steamids: steam_id)
  end

  # Iegūst visas Steam lietotāja piederošās spēles
  def owned_games(steam_id)
    get('/IPlayerService/GetOwnedGames/v0001/',
        steamid: steam_id,
        include_appinfo: true,
        include_played_free_games: true)
  end

  # Iegūst Steam spēles informāciju
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

  # Iegūst Steam lietotāja profila līmeni
  def user_level(steam_id)
    get('/IPlayerService/GetSteamLevel/v1/', steamid: steam_id)
  end

  # Apstrādā un atgriež spēles detalizēto informāciju
  def fetch_game_details(app_id)
    steam_api = SteamApi.new
    game_data = steam_api.game_info(app_id)
    return unless game_data.present? && game_data.values.first['success']

    game_data.values.first['data']
  end

  # Iegūst detalizētu lietotāja statistiku konkrētā spēlē
  def user_stats_for_game(steam_id, app_id)
    get('/ISteamUserStats/GetUserStatsForGame/v0002/', steamid: steam_id, appid: app_id)
  end

  private

  # Universāla metode GET pieprasījumu veikšanai uz Steam Web API
  def get(endpoint, params = {})
    response = @connection.get(endpoint, params.merge(key: @api_key))
    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("SteamApi#get error for #{endpoint}: #{e.message}")
    nil
  end
end
