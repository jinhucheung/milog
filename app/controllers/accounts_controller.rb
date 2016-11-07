class AccountsController < ApplicationController
  before_action :check_signed_in, only: [:edit, :update]

  def new
    @user = User.new
    render layout: 'login'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AccountsMailer.active_account(@user).deliver
      flash[:info] = I18n.t "flash.info.validated_mail"
      sign_in @user
      redirect_to user_path(@user.username)
    else
      # 当I18n切换语系时, 自定义的用户名格式错误提示(errors.username_format)没有被切换
      # 手动切换
      # 下面方法不能很好解决这个问题
      index = @user.errors[:username].index { | msg | msg == User::TIPS_USERNAME_FORMAT_MSG }
      @user.errors[:username][index] = I18n.t("errors.username_format")  unless index.nil?
      render "new", layout: 'login'
    end
  end

  def edit
    @user = current_user
    render layout: 'blog'
  end

  def update
    @user = current_user
    if params[:by].nil?
      if @user.update_attributes(profile_params)
      end
    elsif params[:by] == 'psw' 
      render html: "psw"
    else
      render html: "avatar"
    end
    render 'edit', layout: 'blog'
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

    def profile_params
      params.require(:user).permit(:nickname, :email_public, :github, :weibo, :website, :bio)
    end
end
