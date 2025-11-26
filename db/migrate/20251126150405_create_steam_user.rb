class CreateSteamUser < ActiveRecord::Migration[8.0]
  def change
    create_table :steam_users do |t|
      t.string :steam_id
      t.string :name
      t.string :profile_image_url
      t.string :profile_url
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.timestamps
    end
  end
end
