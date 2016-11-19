class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :content,           null: false
      t.text :content_html
      t.integer :user_id,        null: false
      t.integer :guest_id
      t.integer :article_id,     null: false
      t.integer :index,          null: false, default: 1

      t.timestamps

      t.index :article_id, name: "index_comments_on_article_id"
      t.index [:article_id, :index], name: "index_comments_on_article_id_and_index", unique: true
    end
  end
end
