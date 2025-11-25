require 'rspotify'

class SpotifyController < ApplicationController
  def spotify
    session[:spotify_auth] = request.env['omniauth.auth']
    spotify_user_data = RSpotify::User.new(session[:spotify_auth])

    spotify_user_record =
      (current_user.spotify_user || current_user.build_spotify_user).tap do |su|
        su.update(
          display_name: spotify_user_data.display_name,
          profile_image_url: spotify_user_data.images.first&.[]('url'),
          user_id: current_user.id
        )
      end

    save_top_artists(spotify_user_data, spotify_user_record)
    save_top_songs(spotify_user_data, spotify_user_record)

    redirect_to dashboard_path
  end

  private

  def save_top_artists(spotify_user_data, spotify_user_record)
    spotify_user_record.top_artists.delete_all

    {
      'long_term' => 'all_time',
      'medium_term' => '6_months',
      'short_term' => '4_weeks'
    }.each do |api_range, period_name|
      artists = spotify_user_data.top_artists(limit: 50, time_range: api_range)

      artists.each_with_index do |artist, index|
        spotify_user_record.top_artists.create!(
          name: artist.name,
          spotify_id: artist.id,
          image_url: artist.images.first&.[]('url'),
          period: period_name,
          rank: index + 1
        )
      end
    end
  end

  def save_top_songs(spotify_user_data, spotify_user_record)
    spotify_user_record.top_songs.delete_all

    {
      'long_term' => 'all_time',
      'medium_term' => '6_months',
      'short_term' => '4_weeks'
    }.each do |api_range, period_name|
      songs = spotify_user_data.top_tracks(limit: 50, time_range: api_range)

      songs.each_with_index do |song, index|
        spotify_user_record.top_songs.create!(
          name: song.name,
          album_name: song.album.name,
          spotify_id: song.id,
          image_url: song.album.images.first&.[]('url'),
          period: period_name,
          rank: index + 1
        )
      end
    end
  end
end
