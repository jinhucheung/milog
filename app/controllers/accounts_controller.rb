class AccountsController < ApplicationController
  before_action :check_signed_in, only: [:edit, :update]
  before_action :check_activated, only: [:edit, :update]

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
    if params[:by].blank?             
      update_profile   # 个人资料
    elsif params[:by] == 'psw'     
      update_password  # 密码
    elsif params[:by] == 'avatar' 
      update_avatar    # 头像
    else
      flash.now[:danger] = I18n.t "flash.danger.params_invalid"
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

    def strip_link_on_profile_params
      params[:user][:github].strip!
      params[:user][:weibo].strip!
      params[:user][:website].strip!     
    end

    def psw_params
      params.require(:user).permit(:cur_psw, :new_psw, :new_psw_confirmation)
    end

    def avatar_params
      params.require(:user).permit(:avatar)
    end

    def valid_params?(attri)
      if send("#{attri}_params").empty?
        flash.now[:danger] = I18n.t "flash.danger.params_invalid"
        return false
      end
      true
    end

    def update_profile
      return unless valid_params? :profile
      strip_link_on_profile_params
      return flash.now[:success] = I18n.t("flash.success.update_profile") if @user.update_attributes_by_each(profile_params)
      flash.now[:warning] = I18n.t "flash.warning.update_profile"
    end

    def update_password
      return unless valid_params? :psw
      return @user.errors.add(:current_password, I18n.t("invalid")) unless @user.authenticated? :password, psw_params[:cur_psw]
      if @user.update_attributes password: psw_params[:new_psw], password_confirmation: psw_params[:new_psw_confirmation]
        flash.now[:success] = I18n.t "flash.success.reset_password"
      end
    end

    def update_avatar
      return unless valid_params? :avatar
      @user.avatar = avatar_params[:avatar]
      @user.valid?
      if @user.errors.include? :avatar
        flash.now[:warning] = I18n.t "flash.warning.avatar_too_big", size: 1
        @user.reload
      else
        @user.update_attribute :avatar, avatar_params[:avatar] 
        flash.now[:success] = I18n.t "flash.success.update_avatar"
      end
      @user.errors.clear
    end
end
