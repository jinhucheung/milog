class UsersController < ApplicationController
  layout "blog", only: [:show]
  def show
    @user = User.find_by username: params[:id]
  end

  def edit
    
  end
end
