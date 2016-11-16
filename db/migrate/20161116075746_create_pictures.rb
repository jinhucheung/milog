class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.string :picture,       null: false

      t.timestamps
    end
  end
end
