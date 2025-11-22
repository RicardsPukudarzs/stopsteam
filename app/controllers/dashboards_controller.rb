class DashboardsController < ApplicationController
  def index
    return unless session[:spotify_auth]

    spotify_user = RSpotify::User.new(session[:spotify_auth])

    @top_artists_all_time = spotify_user.top_artists(limit: 50, time_range: 'long_term').map do |artist|
      { name: artist.name, image: artist.images.first&.[]('url') }
    end

    @top_artists_last_6_months = spotify_user.top_artists(limit: 50, time_range: 'medium_term').map do |artist|
      { name: artist.name, image: artist.images.first&.[]('url') }
    end

    @top_artists_last_4_weeks = spotify_user.top_artists(limit: 50, time_range: 'short_term').map do |artist|
      { name: artist.name, image: artist.images.first&.[]('url') }
    end

    @top_songs_all_time = spotify_user.top_tracks(limit: 50, time_range: 'long_term').map do |track|
      { name: track.name, album: track.album.name, image: track.album.images.first&.[]('url') }
    end

    @top_songs_last_6_months = spotify_user.top_tracks(limit: 50, time_range: 'medium_term').map do |track|
      { name: track.name, album: track.album.name, image: track.album.images.first&.[]('url') }
    end

    @top_songs_last_4_weeks = spotify_user.top_tracks(limit: 50, time_range: 'short_term').map do |track|
      { name: track.name, album: track.album.name, image: track.album.images.first&.[]('url') }
    end
  end
end
