class CreateUserCategoryships < ActiveRecord::Migration[5.0]
  def change
    create_table :user_categoryships do |t|
      t.integer :user_id,               null: false
      t.integer :category_id,           null: false
      t.index [:user_id, :category_id], name: "index_user_categoryships_on_user_id_and_category_id",
                                        unique: true
    end
  end
end
