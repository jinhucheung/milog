class AddUserIdIndexToComments < ActiveRecord::Migration[5.0]
  def change
    add_index :comments, :user_id, name: 'index_comments_on_user_id'
  end
end
