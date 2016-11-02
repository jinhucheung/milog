class HomeController < ApplicationController

  def index
  	if signed_in?
  		redirect_to user_path(current_user.username)
  	else
  		redirect_to signin_path
  	end
  end
end
