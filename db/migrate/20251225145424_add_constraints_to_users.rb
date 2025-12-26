class AddConstraintsToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.change_null :username, false
      t.change_null :email, false
      t.change_null :password_digest, false
      t.index :email, unique: true
    end
  end
end
