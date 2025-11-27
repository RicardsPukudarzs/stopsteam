class AddUserLevelToSteamUser < ActiveRecord::Migration[8.0]
  def change
    add_column :steam_users, :user_level, :integer
  end
end
