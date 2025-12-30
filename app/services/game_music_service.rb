class GameMusicService
  def initialize(app_id)
    @app_id = app_id
  end

  def top_artists
    user_games = UserGame.includes(:steam_user).where(app_id: @app_id)
    return [] if user_games.blank?

    user_weights = calculate_user_weights(user_games)
    return [] if user_weights.blank?

    weighted_artists = Hash.new { |h, k| h[k] = { weight: 0, image_url: nil } }
    user_weights.each do |user_id, weight|
      user = User.find_by(id: user_id)
      next unless user&.spotify_user

      user_top_artists = user.spotify_user.top_artists.where(period: 'last_year').order(:rank).limit(10)
      user_top_artists.each do |artist|
        weighted_artists[artist.name][:weight] += weight
        weighted_artists[artist.name][:image_url] ||= artist.image_url
      end
    end

    weighted_artists.sort_by { |_name, data| -data[:weight] }
                    .map { |name, data| { name: name, image_url: data[:image_url], weight: data[:weight] } }
                    .first(9)
  end

  def top_tracks
    user_games = UserGame.includes(:steam_user).where(app_id: @app_id)
    return [] if user_games.blank?

    user_weights = calculate_user_weights(user_games)
    return [] if user_weights.blank?

    weighted_tracks = Hash.new { |h, k| h[k] = { weight: 0, image_url: nil, artist_name: nil } }
    user_weights.each do |user_id, weight|
      user = User.find_by(id: user_id)
      next unless user&.spotify_user

      user_top_tracks = user.spotify_user.top_songs.where(period: 'last_year').order(:rank).limit(10)
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

  private

  def calculate_user_weights(user_games)
    user_games.each_with_object({}) do |user_game, weights|
      next unless user_game.steam_user

      weights[user_game.steam_user.user_id] = user_game.playtime_hours
    end
  end
end
