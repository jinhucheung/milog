class AddUserIdToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :user_id, :integer,  null: false
    add_index  :pictures, :user_id, name: 'index_pictures_on_user_id' 
  end
end
