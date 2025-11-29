class GamesController < ApplicationController
  def show
    app_id = params[:app_id]
    @top_artists = top_artists(app_id)
    @top_tracks = top_tracks(app_id)
    @game_details = fetch_game_details(app_id)
    @name = game_name(@game_details)
    @short_desc = short_description(@game_details)
    @header_img = header_image(@game_details)
    @price = price_overview_final_formatted(@game_details)
    @categories = first_three_categories(@game_details)
    @release_date = release_date(@game_details)
    @developers = developers(@game_details)
    @publishers = publishers(@game_details)
  end

  private

  def top_artists(app_id)
    user_games = UserGame.includes(:steam_user).where(app_id: app_id)
    user_weights = calculate_user_weights(user_games)

    weighted_artists = Hash.new { |h, k| h[k] = { weight: 0, image_url: nil } }
    user_weights.each do |user_id, weight|
      user = User.find(user_id)
      user_top_artists = user.spotify_user.top_artists.limit(9)
      user_top_artists.each do |artist|
        weighted_artists[artist.name][:weight] += weight
        weighted_artists[artist.name][:image_url] ||= artist.image_url
      end
    end

    weighted_artists.sort_by { |_name, data| -data[:weight] }
                    .map { |name, data| { name: name, image_url: data[:image_url], weight: data[:weight] } }
                    .first(9)
  end

  def top_tracks(app_id)
    user_games = UserGame.includes(:steam_user).where(app_id: app_id)
    user_weights = calculate_user_weights(user_games)

    weighted_tracks = Hash.new { |h, k| h[k] = { weight: 0, image_url: nil, artist_name: nil } }
    user_weights.each do |user_id, weight|
      user = User.find(user_id)
      user_top_tracks = user.spotify_user.top_songs.limit(10)

      user_top_tracks.each do |track|
        weighted_tracks[track.name][:weight] += weight
        weighted_tracks[track.name][:image_url] ||= track.image_url
        weighted_tracks[track.name][:artist_name] ||= track.artist_name
      end
    end

    weighted_tracks.sort_by { |_name, data| -data[:weight] }
                   .map { |name, data| { name: name, image_url: data[:image_url], artist_name: data[:artist_name], weight: data[:weight] } }
                   .first(10)
  end

  def calculate_user_weights(user_games)
    user_games.each_with_object({}) do |user_game, weights|
      weights[user_game.steam_user.user_id] = user_game.playtime_hours
    end
  end

  def fetch_game_details(app_id)
    steam_api = SteamApi.new
    game_data = steam_api.game_info(app_id)
    return unless game_data.present? && game_data.values.first['success']

    game_data.values.first['data']
  end

  def game_name(game_details)
    game_details['name'] if game_details
  end

  def short_description(game_details)
    game_details['short_description'] if game_details
  end

  def header_image(game_details)
    game_details['header_image'] if game_details
  end

  def price_overview_final_formatted(game_details)
    if game_details && game_details['price_overview'] && game_details['price_overview']['final_formatted'].present?
      game_details['price_overview']['final_formatted']
    else
      'Free'
    end
  end

  def first_three_categories(game_details)
    return [] unless game_details && game_details['categories']

    game_details['categories'].first(3).pluck('description')
  end

  def release_date(game_details)
    game_details.dig('release_date', 'date') if game_details && game_details['release_date']
  end

  def developers(game_details)
    game_details['developers'] if game_details && game_details['developers']
  end

  def publishers(game_details)
    game_details['publishers'] if game_details && game_details['publishers']
  end
end
