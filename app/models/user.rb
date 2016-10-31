class User < ApplicationRecord
	USERNAME_FORMAT = /\A[a-zA-Z0-9\-\_]+\z/
	EMAIL_FORMAT = /\A[\w\+\-\.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :username, :email, :password, presence: true
	validates :username, length: { minimum: 6, too_short: I18n.t("error_tip.too_short") },
											 format: { with: USERNAME_FORMAT, message: I18n.t("error_tip.username_format") },
											 uniqueness: { case_sensitive: false }
	validates :email,	format: { with: EMAIL_FORMAT },
										uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6, too_short: I18n.t("error_tip.too_short") }

	# 需引入gem bcrypt
	has_secure_password

	before_save :downcase_username_and_email

	private
		def downcase_username_and_email
			username.downcase!
			email.downcase!
		end
end
