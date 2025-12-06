class CreateGameStats < ActiveRecord::Migration[8.0]
  def change
    create_table :game_stats do |t|
      t.references :steam_user, null: false, foreign_key: true
      t.integer :app_id, null: false
      t.string :stat_name, null: true
      t.integer :stat_value, null: true
      t.timestamps
    end
  end
end
