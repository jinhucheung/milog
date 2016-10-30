class User < ApplicationRecord
	# 需引入gem bcrypt
	has_secure_password
end
