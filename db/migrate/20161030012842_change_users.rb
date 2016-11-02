class ChangeUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.rename :user_website, :website
      t.index :username, name: "index_users_on_username", unique: true, using: :btree
      t.index :email, name: "index_users_on_email", unique: true, using: :btree
    end
  end
end
