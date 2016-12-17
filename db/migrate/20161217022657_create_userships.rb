class CreateUserships < ActiveRecord::Migration[5.0]
  def change
    create_table :userships do |t|
      t.integer :follower_id,       null: false
      t.integer :following_id,      null: false

      t.index [:follower_id, :following_id], name: 'index_userships_on_follower_id_and_following_id', unique: true
    end
  end
end
