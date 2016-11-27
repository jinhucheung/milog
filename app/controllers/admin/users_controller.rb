class Admin::UsersController < ApplicationController
  before_action :check_signed_in
  before_action :check_activated
  before_action :check_admin

  layout 'admin'

  def index
    @user = current_user
    case params[:by]
    when 'normal'
      @value = 2
      @users = User.normal.paginate page: params[:page], per_page: 15
    when 'admin'
      @value = 3
      @users = User.admin.paginate page: params[:page], per_page: 15
    when 'disabled'
      @value = 4
      @users = User.disabled.paginate page: params[:page], per_page: 15
    else 
      @value = 1
      @users = User.all.paginate page: params[:page], per_page: 15
    end
  end


end