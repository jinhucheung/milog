class Accounts::ActivationsController < ApplicationController
  before_action :check_signed_in, only: [:new]
  before_action :get_current_user, only: [:new]
  before_action :check_params, only: [:edit]
  before_action :get_params_user, only: [:edit]
  before_action :check_activated, only: [:new, :edit]

  # 重新发送激活链接
  def new
    @user.generate_activation_digest
    AccountsMailer.active_account(@user).deliver
    flash[:info] = I18n.t "flash.info.validated_mail"
    redirect_to user_path(@user.username)
  end

  # 验证激活链接
  def edit
    return render_404 if !@user.authenticated? :activation, params[:token]

    if @user.digest_expired? :activated
      flash[:warning] = I18n.t 'flash.warning.link_expired'
      redirect_to root_path
    else
      flash[:success] = I18n.t 'flash.success.active_account'
      @user.active
      redirect_to user_path(@user.username)
    end
  end

  private 
    def get_current_user
      @user = current_user
    end

    def get_params_user
      @user = User.find_by username: params[:id]
    end

    def check_params
      return render_404 unless params[:id] && params[:token]
    end

    def check_signed_in
      return render_404 unless signed_in?
    end

    def check_activated
      return render_404 if @user.nil? || @user.activated?
    end
end