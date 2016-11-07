class AddEmailPublicToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.boolean :email_public, default: false
    end
  end
end
