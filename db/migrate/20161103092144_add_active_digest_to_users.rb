class AddActiveDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :activation_digest
      t.boolean :activated, default: false
      t.datetime :activated_at
    end
  end
end
