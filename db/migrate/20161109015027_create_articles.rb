class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title,              null: false
      t.text :content
      t.boolean :posted,            default: false
      t.integer :view_count,        default: 0
      t.integer :comment_count,     default: 0
      t.integer :user_id,           null: false
      t.integer :category_id,       null: false
      t.timestamps

      t.index [:user_id], name: "index_articles_on_user_id"
      t.index [:user_id, :category_id],  name: "index_articles_on_user_id_and_category_id", using: :btree
      t.index [:user_id, :created_at], name: "index_articles_on_user_id_and_created_at", using: :btree
    end
  end
end
