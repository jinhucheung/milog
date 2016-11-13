class CreateUserTagships < ActiveRecord::Migration[5.0]
  def change
    create_table :user_tagships do |t|
      t.integer :user_id,           null: false
      t.integer :tag_id,            null: false
      t.index [:user_id, :tag_id], name: 'index_user_tagships_on_user_id_and_tag_id',
                                   unique: true
    end
  end
end
