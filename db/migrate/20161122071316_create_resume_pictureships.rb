class CreateResumePictureships < ActiveRecord::Migration[5.0]
  def change
    create_table :resume_pictureships do |t|
      t.integer :resume_id
      t.integer :picture_id
      t.index [:resume_id, :picture_id], name: "index_resume_pictureships_on_resume_id_and_picture_id", unique: true
    end
  end
end
