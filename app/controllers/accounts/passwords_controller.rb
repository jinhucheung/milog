class Accounts::PasswordsController < ApplicationController

  before_action :check_params, only: [:edit, :update]
  before_action :get_user, only: [:edit, :update]
  before_action :check_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.new 
    email = params[:forgot][:email]
    if email.nil? || email !~ User::EAMIL_FORMAT_REGEXP
      @user.errors.add :email, I18n.t("errors.invalid_format")   
    elsif (user = User.find_by email: email).nil?
      @user.errors.add :email, I18n.t("errors.not_find")   
    else
      user.generate_reset_password_digest
      AccountsMailer.reset_password(user).deliver     
      flash.now[:info] =  I18n.t "flash.info.psw_reset_mail" 
    end
    render 'new'
  end

  def edit
  end

  def update
    if @user.update_attributes reset_password_params
      @user.del_attr_digest :reset_password
      flash[:info] = I18n.t "flash.success.reset_password"
      redirect_to signin_path  
    else
      render 'edit'
    end
  end

  private
    def reset_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def check_params
      return render_404 unless params[:id] && params[:token]
    end

    def get_user
      @user = User.find_by username: params[:id]
    end

    def check_user
      return render_404 unless @user && @user.authenticated?(:reset_password, params[:token])
    end

    def check_expiration
      if @user.digest_expired? :reset_password
        flash[:warning] = I18n.t 'flash.warning.link_expired'
        redirect_to root_path
      end
    end

end
