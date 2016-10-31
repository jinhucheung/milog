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
	  	render "new"
	  end
	end

  private 
  	def user_params
      params.require(:user).permit(:username, :email, :password)
  	end
end
