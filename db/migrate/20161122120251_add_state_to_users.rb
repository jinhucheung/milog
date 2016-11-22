class AddStateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :state, :integer, default: 1, null: false
  end
end
