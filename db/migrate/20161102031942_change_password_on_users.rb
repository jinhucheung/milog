class ChangePasswordOnUsers < ActiveRecord::Migration[5.0]
  def change
  	change_table :users do |t|
  		t.rename :password_digest, :password_hash
  	end
  end
end
