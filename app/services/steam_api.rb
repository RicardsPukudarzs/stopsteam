class SteamApi
  BASE_URL = 'https://api.steampowered.com'.freeze

  def initialize
    @api_key = ENV.fetch('STEAM_API_KEY', nil)
    @connection = Faraday.new(url: BASE_URL)
  end

  def player_summary(steam_id)
    endpoint = '/ISteamUser/GetPlayerSummaries/v0002/'
    response = @connection.get(endpoint, {
                                 key: @api_key,
                                 steamids: steam_id
                               })

    JSON.parse(response.body)
  end

  def owned_games(steam_id)
    endpoint = '/IPlayerService/GetOwnedGames/v0001/'
    response = @connection.get(endpoint, {
                                 key: @api_key,
                                 steamid: steam_id,
                                 include_appinfo: true,
                                 include_played_free_games: true
                               })

    JSON.parse(response.body)
  end

  def game_info(app_id)
    url = 'https://store.steampowered.com/api/appdetails'
    response = Faraday.get(url, { appids: app_id })

    return nil unless response.success?

    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("SteamApi#game_info error for app_id=#{app_id}: #{e.message}")
    nil
  end

  def user_level(steam_id)
    endpoint = '/IPlayerService/GetSteamLevel/v1/'
    response = @connection.get(endpoint, {
                                 key: @api_key,
                                 steamid: steam_id
                               })

    JSON.parse(response.body)
  end

  def user_game_info(steam_id, app_id)
    endpoint = '/IPlayerService/GetUserGameInfo/v1/'
    response = @connection.get(endpoint, {
                                 key: @api_key,
                                 steamid: steam_id,
                                 appid: app_id
                               })

    JSON.parse(response.body)
  end
end
