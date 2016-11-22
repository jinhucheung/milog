class CreateResumes < ActiveRecord::Migration[5.0]
  def change
    create_table :resumes do |t|
      t.text :content
      t.text :content_html
      t.boolean :posted,        default: false
      t.integer :user_id,       null: false

      t.timestamps
      t.index :user_id, name: "index_resumes_on_user_id", unique: true
    end
  end
end
