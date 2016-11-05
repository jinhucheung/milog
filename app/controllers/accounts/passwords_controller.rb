class Accounts::PasswordsController < ApplicationController
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
    render 'new'
  end

  def update

  end

end
