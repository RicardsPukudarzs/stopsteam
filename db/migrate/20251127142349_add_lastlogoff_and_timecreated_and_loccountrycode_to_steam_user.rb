class AddLastlogoffAndTimecreatedAndLoccountrycodeToSteamUser < ActiveRecord::Migration[8.0]
  def change
    add_column :steam_users, :last_log_off, :integer
    add_column :steam_users, :time_created, :integer
    add_column :steam_users, :loc_country_code, :string
  end
end
