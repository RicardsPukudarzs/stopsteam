class CreateSpotifyUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :spotify_users do |t|
      t.string :display_name
      t.string :profile_image_url
      t.string :spotify_id, null: false
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
