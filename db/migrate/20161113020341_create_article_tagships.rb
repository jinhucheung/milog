class CreateArticleTagships < ActiveRecord::Migration[5.0]
  def change
    create_table :article_tagships do |t|
      t.integer :article_id,          null: false
      t.integer :tag_id,              null: false
      t.index [:article_id, :tag_id], name: 'index_article_tagships_on_article_id_and_tag_id',
                                      unique: true
    end
  end
end
