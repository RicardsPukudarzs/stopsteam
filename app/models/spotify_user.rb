class SpotifyUser < ApplicationRecord
  belongs_to :user
  has_many :top_artists, dependent: :destroy
  has_many :top_songs, dependent: :destroy

  def top_artists_by_period(period, limit = 50)
    top_artists.where(period: period).order(:rank).limit(limit).map do |artist|
      { name: artist.name, image: artist.image_url }
    end
  end

  def top_songs_by_period(period, limit = 50)
    top_songs.where(period: period).order(:rank).limit(limit).map do |track|
      { name: track.name, album: track.album_name, image: track.image_url, artist: track.artist_name }
    end
  end
end

# == Schema Information
#
# Table name: spotify_users
#
# id                :bigint           not null, primary key
# display_name      :string
# profile_image_url :string
# user_id           :bigint           not null, unique, foreign key
# created_at        :datetime         not null
# updated_at        :datetime         not null
