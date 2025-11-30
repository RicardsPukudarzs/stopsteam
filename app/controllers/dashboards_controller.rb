class DashboardsController < ApplicationController
  before_action :require_logged_in

  def index
    if current_user.spotify_user
      @top_artists_all_time = current_user.spotify_user.top_artists.where(period: 'all_time').order(:rank).limit(50).map do |artist|
        { name: artist.name, image: artist.image_url }
      end

      @top_artists_last_6_months = current_user.spotify_user.top_artists.where(period: '6_months').order(:rank).limit(50).map do |artist|
        { name: artist.name, image: artist.image_url }
      end

      @top_artists_last_4_weeks = current_user.spotify_user.top_artists.where(period: '4_weeks').order(:rank).limit(50).map do |artist|
        { name: artist.name, image: artist.image_url }
      end

      @top_songs_all_time = current_user.spotify_user.top_songs.where(period: 'all_time').order(:rank).limit(50).map do |track|
        { name: track.name, album: track.album_name, image: track.image_url, artist: track.artist_name }
      end

      @top_songs_last_6_months = current_user.spotify_user.top_songs.where(period: '6_months').order(:rank).limit(50).map do |track|
        { name: track.name, album: track.album_name, image: track.image_url, artist: track.artist_name }
      end

      @top_songs_last_4_weeks = current_user.spotify_user.top_songs.where(period: '4_weeks').order(:rank).limit(50).map do |track|
        { name: track.name, album: track.album_name, image: track.image_url, artist: track.artist_name }
      end
    end

    return unless current_user.steam_user

    @steam_user_games = current_user.steam_user.user_games.order(playtime_forever: :desc)
  end
end
