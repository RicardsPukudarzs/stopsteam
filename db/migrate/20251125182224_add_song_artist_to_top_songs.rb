class AddSongArtistToTopSongs < ActiveRecord::Migration[8.0]
  def change
    add_column :top_songs, :artist_name, :string
  end
end
