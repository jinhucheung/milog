class AddCleanedToHolds < ActiveRecord::Migration[5.0]
  def change
    add_column :holds, :cleaned, :boolean, default: false
  end
end
