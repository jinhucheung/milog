class RemoveAvatarColorFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :avatar_color, :string
  end
end
