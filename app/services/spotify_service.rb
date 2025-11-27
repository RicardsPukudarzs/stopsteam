class SpotifyService
  def initialize(spotify_auth, user)
    @spotify_user_data = RSpotify::User.new(spotify_auth)
    @user = user
    @spotify_user_record = @user.spotify_user || @user.build_spotify_user
  end

  def sync_user
    update_user_record
    sync_top_artists
    sync_top_songs
  end

  private

  def update_user_record
    @spotify_user_record.update(
      display_name: @spotify_user_data.display_name,
      profile_image_url: @spotify_user_data.images.first&.[]('url'),
      user_id: @user.id
    )
  end

  def sync_top_artists
    {
      'long_term' => 'all_time',
      'medium_term' => '6_months',
      'short_term' => '4_weeks'
    }.each do |api_range, period_name|
      artists = @spotify_user_data.top_artists(limit: 50, time_range: api_range)

      artists.each_with_index do |artist, index|
        record = @spotify_user_record.top_artists.find_or_initialize_by(
          spotify_id: artist.id,
          period: period_name
        )
        record.update(
          name: artist.name,
          image_url: artist.images.first&.[]('url'),
          rank: index + 1
        )
      end
    end
  end

  def sync_top_songs
    {
      'long_term' => 'all_time',
      'medium_term' => '6_months',
      'short_term' => '4_weeks'
    }.each do |api_range, period_name|
      songs = @spotify_user_data.top_tracks(limit: 50, time_range: api_range)

      songs.each_with_index do |song, index|
        record = @spotify_user_record.top_songs.find_or_initialize_by(
          spotify_id: song.id,
          period: period_name
        )
        record.update(
          name: song.name,
          album_name: song.album.name,
          artist_name: song.artists.map(&:name).join(', '),
          image_url: song.album.images.first&.[]('url'),
          rank: index + 1
        )
      end
    end
  end
end
