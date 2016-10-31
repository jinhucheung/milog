class User < ApplicationRecord
	USERNAME_FORMAT = /\A[a-zA-Z0-9\-\_\.]+\z/
	EMAIL_FORMAT = /\A[\w\+\-\.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :username, :email, :password, presence: true
	validates :username, length: { minimum: 6, too_short: "must have at least %{count} words"},
											 format: { with: USERNAME_FORMAT },
											 uniqueness: { case_sensitive: false }
	validates :email,	format: { with: EMAIL_FORMAT },
										uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

	# 需引入gem bcrypt
	has_secure_password

	before_save :downcase_username_and_email

	private
		def downcase_username_and_email
			username.downcase!
			email.downcase!
		end
end
