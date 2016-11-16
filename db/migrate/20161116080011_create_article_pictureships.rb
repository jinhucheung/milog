class CreateArticlePictureships < ActiveRecord::Migration[5.0]
  def change
    create_table :article_pictureships do |t|
      t.integer :article_id,           null: false
      t.integer :picture_id,           null: false

      t.index [:article_id, :picture_id], name: 'index_article_pictureships_on_article_id_and_picture_id',
                                          unique: true
    end
  end
end
