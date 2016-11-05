class AddResetPswToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :reset_password_digest
      t.datetime :reset_password_at
    end
  end
end
