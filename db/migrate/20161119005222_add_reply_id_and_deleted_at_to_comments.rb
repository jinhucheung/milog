class AddReplyIdAndDeletedAtToComments < ActiveRecord::Migration[5.0]
  def change
    change_table :comments do |t|
      t.integer  :reply_id
      t.datetime :deleted_at
    end
  end
end
