class AccountsController < ApplicationController
  def new
  	@user = User.new
  end

	def create
	  @user = User.new(user_params) 
	  if @user.save
	    render html: "success"
	  else
	  	render "new"
	  end
	end

  private 
  	def user_params
      params.require(:user).permit(:username, :email, :password)
  	end
end
