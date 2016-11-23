class CreateHolds < ActiveRecord::Migration[5.0]
  def change
    create_table :holds do |t|
      t.integer :user_id,         null: false
      t.string  :holdable_type,   null: false
      t.integer :holdable_id
      t.text    :content

      t.string  :title
      t.integer :category_id
      t.string  :tagstr

      t.index :user_id, name: "index_holds_on_user_id"
    end
  end
end
