class CreateUserGames < ActiveRecord::Migration[8.0]
  def change
    create_table :user_games do |t|
      t.integer :app_id
      t.string :name
      t.integer :playtime_forever
      t.string :img_icon_url
      t.integer :rtime_last_played
      t.references :steam_user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
