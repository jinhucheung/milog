class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :name,       null: false
      t.index :name, name: "index_tags_on_name", unique: true
    end
  end
end
