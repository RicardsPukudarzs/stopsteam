class ChangeStatValueToBigintInGameStats < ActiveRecord::Migration[8.0]
  def change
    change_column :game_stats, :stat_value, :bigint
  end
end
