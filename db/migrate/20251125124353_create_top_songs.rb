class CreateTopSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :top_songs do |t|
      t.string :name
      t.string :album_name
      t.string :spotify_id
      t.string :image_url
      t.string :period
      t.integer :rank
      t.references :spotify_user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
