class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string  'username',                     null: false 
      t.string  'email',                        null: false 
      
      t.string  'nickname'
      t.string  'avatar'
      t.string  'bio'
      t.string  'city'

      t.string  'github'
      t.string  'weibo'

      t.boolean 'admin',         default: false, null: false

      t.string 'password_digest'

      t.timestamps
    end
  end
end
