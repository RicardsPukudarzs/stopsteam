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
end
