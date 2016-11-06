class SessionsController < ApplicationController
  layout "login"

  def new
    # 注册/登录同页面, 同时使用User_Model中的验证返回信息
    @user = User.new
  end

  def create
    @user = User.find_by email: session_param(:email)
    if @user && @user.authenticated?(:password, session_param(:password))
      sign_in @user
      session_param(:remember_me) == "1" ? remember_me(@user) : forget_me(@user)
      redirect_to user_path(@user.username)
    elsif @user
      # 密码错误
      @user.errors.add :password, I18n.t("errors.not_right")
      render 'new'
    else
      @user = build_user "", session_param(:email), session_param(:password)
      @user.valid? || @user.errors.delete(:username)
      @user.errors.add :email, I18n.t("errors.email_disabled") if @user.errors.full_messages.empty?
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private 
    def session_param(attribute)
      params[:session][attribute]
    end
end
