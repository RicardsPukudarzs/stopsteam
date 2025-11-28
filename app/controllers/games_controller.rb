class GamesController < ApplicationController
  def show
    app_id = params[:app_id]
    @top_artists = top_artists(app_id)
    @top_tracks = top_tracks(app_id)
  end

  private

  def top_artists(app_id)
    user_games = UserGame.includes(:steam_user).where(app_id: app_id)
    user_weights = calculate_user_weights(user_games)

    weighted_artists = Hash.new(0)
    user_weights.each do |user_id, weight|
      user = User.find(user_id)
      user_top_artists = user.spotify_user.top_artists.limit(10)

      user_top_artists.each do |artist|
        weighted_artists[artist.name] += weight
      end
    end

    weighted_artists.sort_by { |_artist, weight| -weight }.to_h
  end

  def top_tracks(app_id)
    user_games = UserGame.includes(:steam_user).where(app_id: app_id)
    user_weights = calculate_user_weights(user_games)

    weighted_tracks = Hash.new(0)
    user_weights.each do |user_id, weight|
      user = User.find(user_id)
      user_top_tracks = user.spotify_user.top_songs.limit(10)

      user_top_tracks.each do |track|
        weighted_tracks[track.name] += weight
      end
    end

    weighted_tracks.sort_by { |_track, weight| -weight }.to_h
  end

  def calculate_user_weights(user_games)
    user_games.each_with_object({}) do |user_game, weights|
      weights[user_game.steam_user.user_id] = user_game.playtime_hours
    end
  end
end
