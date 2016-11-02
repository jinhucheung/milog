module SessionsHelper

	def sign_in(user) 
		session[:username] = user.username
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user
		@current_user ||= User.find_by username: session[:username] 
		unless  @current_user
			user = User.find_by username: cookies.signed[:username]
			return nil unless user
			@current_user = user if	user.authenticated? :remember, cookies.signed[:remember_token]
		end
		@current_user
	end

	def remember_me(user)
		user.new_remember_digest
		cookies.permanent.signed[:remember_token] = user.remember_token
		cookies.permanent.signed[:username] = user.username
	end

	def forget_me(user)
		user.del_remember_digest
		cookies.delete :remember_token
		cookies.delete :username
	end

	def sign_out
		return unless signed_in?
		session.delete :username
		forget_me @current_user
		@current_user = nil
	end
end
