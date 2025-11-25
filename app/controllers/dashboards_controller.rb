class DashboardsController < ApplicationController
  before_action :require_logged_in

  def index
    return unless current_user.spotify_user

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
      { name: track.name, album: track.album_name, image: track.image_url }
    end

    @top_songs_last_6_months = current_user.spotify_user.top_songs.where(period: '6_months').order(:rank).limit(50).map do |track|
      { name: track.name, album: track.album_name, image: track.image_url }
    end

    @top_songs_last_4_weeks = current_user.spotify_user.top_songs.where(period: '4_weeks').order(:rank).limit(50).map do |track|
      { name: track.name, album: track.album_name, image: track.image_url }
    end
  end

  def test
    return unless session[:spotify_auth]

    spotify_user = RSpotify::User.new(session[:spotify_auth])

    @user_top_songs = spotify_user.top_tracks(limit: 10, time_range: 'short_term').map do |track|
      { name: track.name, id: track.id, album: track.album.name, image: track.album.images.first&.[]('url') }
    end
    render json: current_user.spotify_user.top_artists.where(period: '4_weeks')
  end
end
