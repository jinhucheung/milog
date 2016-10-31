class AccountsController < ApplicationController
  def new
  	@user = User.new
  end

	def create
	  @user = User.new(user_params) 
	  if @user.save
	    flash[:info] = I18n.t "flash.info.validated_mail"
	    redirect_to signup_path
	  else
	  	# 当I18n切换语系时, 自定义错误提示(errors.username_format)没有被切换
	  	# 手动切换
	  	if @user.errors[:username].any?
	  		 @user.errors.delete :username
	  		 @user.errors.add :username, I18n.t("errors.username_format") 
	  	end
	  	render "new"
	  end
	end

  private 
  	def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
  	end
end
