class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
  	@user = User.new(user_params) 
  	render 'new'
  end

  private 
  	def user_params
      params.require(:user).permit(:username, :email, :password)
  	end
end
