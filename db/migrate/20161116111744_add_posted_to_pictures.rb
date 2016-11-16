class AddPostedToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :posted, :boolean, default: false
  end
end
