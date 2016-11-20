class CreateCommentPictureships < ActiveRecord::Migration[5.0]
  def change
    create_table :comment_pictureships do |t|
      t.integer :comment_id,              null: false
      t.integer :picture_id,              null: false

      t.index [:comment_id, :picture_id], name: 'index_comment_pictureships_on_comment_id_and_picture_id',
                                          unique: true
    end
  end
end
