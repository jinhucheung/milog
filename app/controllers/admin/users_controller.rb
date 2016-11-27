class Admin::UsersController < ApplicationController
  before_action :check_signed_in
  before_action :check_activated
  before_action :check_admin

  before_action :get_current_user, only: [:index, :new, :create]

  layout 'admin'

  MAX_IN_PAGE = 15

  def index
    case params[:by]
    when 'normal'
      @value = 2
      @users = User.normal.paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'admin'
      @value = 3
      @users = User.admin.paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'disabled'
      @value = 4
      @users = User.disabled.paginate page: params[:page], per_page: MAX_IN_PAGE
    else 
      @value = 1
      @users = User.all.paginate page: params[:page], per_page: MAX_IN_PAGE
    end
  end

  def destroy
    @user = User.find_by username: params[:id]
    if @user
      @user.destroy
      flash[:success] = I18n.t "flash.success.delete_user", name: @user.username
    else
      flash[:warning] = I18n.t "flash.warning.user_not_fount", name: @user.username
    end
    redirect_to admin_users_path
  end

  def new
    @new_user = User.new
    @random_psw = @new_user.new_random_psw
  end

  def create
    @new_user = User.new new_user_params
    if @new_user.valid?
      @new_user.save
      flash.now[:success] = I18n.t "flash.success.create_user", name: @new_user.username
    else
      @random_psw = @new_user.new_random_psw
      flash.now[:warning] = @new_user.errors.full_messages[0]
    end
    render 'new'
  end

  private
    def new_user_params
      params.require(:user).permit :username, :email, :password, :password_confirmation, :state
    end

    def get_current_user
      @user = current_user
    end
end