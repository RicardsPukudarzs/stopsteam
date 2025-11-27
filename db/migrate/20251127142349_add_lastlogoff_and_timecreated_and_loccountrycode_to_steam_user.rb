class AddLastlogoffAndTimecreatedAndLoccountrycodeToSteamUser < ActiveRecord::Migration[8.0]
  def change
    change_table :steam_users, bulk: true do |t|
      t.integer :last_log_off
      t.integer :time_created
      t.string :loc_country_code
    end
  end
end
