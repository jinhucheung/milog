class ChangeBackPasswordOnUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      # has_secure_password 限制了列名, 默认使用_digest结尾
      t.rename :password_hash, :password_digest
    end
  end
end
