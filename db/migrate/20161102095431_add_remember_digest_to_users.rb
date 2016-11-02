class AddRememberDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :remember_digest
    end
  end
end
