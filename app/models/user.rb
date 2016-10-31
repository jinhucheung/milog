class User < ApplicationRecord
	VALID_USERNAME_FORMAT = /\A[a-zA-Z0-9\-\_]+\z/
	VALID_EMAIL_FORMAT = /\A[\w\+\-\.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	TIPS_USERNAME_FORMAT_MSG = 'USERNAME_FORMAT'

	validates :username, :email, :password, presence: true
	validates :username, length: { in: 6..25 },
											 format: { with: VALID_USERNAME_FORMAT, message: TIPS_USERNAME_FORMAT_MSG },
											 uniqueness: { case_sensitive: false }
	validates :email,	length: { maximum: 255 }, 
										format: { with: VALID_EMAIL_FORMAT },
										uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 },
											 allow_nil: true

	# 需引入gem bcrypt
	has_secure_password

	before_save :downcase_username_and_email

	private
		def downcase_username_and_email
			username.downcase!
			email.downcase!
		end
end
