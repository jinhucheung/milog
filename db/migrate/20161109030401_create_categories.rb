class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name,         null: false
      t.index [:name], name: "index_categories_on_name", unique: true
    end
  end
end
