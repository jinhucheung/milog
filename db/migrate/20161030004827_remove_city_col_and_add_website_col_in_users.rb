class RemoveCityColAndAddWebsiteColInUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :city, :string
    add_column :users, :user_website, :string
  end
end
