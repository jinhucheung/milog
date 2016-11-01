class SessionsController < ApplicationController
	include UserHelper

	def new 
		# 注册/登录同页面, 同时使用User_Model中的验证返回信息
  	@user = User.new
	end

	def create
		@user = User.find_by email: params[:user][:email]
		if @user
		
		else 
			@user = buildUser "", params[:user][:email], params[:user][:password]
			@user.valid? || @user.errors.delete(:username)
			@user.errors.add :email, I18n.t("errors.email_disabled") if @user.errors.full_messages.empty?
			render 'new' 
		end
	end

	private 
  	def user_params
      params.require(:user).permit(:email, :password)
  	end
end
