class Api::AccountsController < ApplicationController

  def active
    username = params[:id]
    token = params[:token]
    # link非法检测
    flash[:danger] = I18n.t 'flash.danger.link_invalid'
    return render_404 unless username && token

    @user = User.find_by username: username
    return render_404 if @user.nil?

    return redirect_to root_path if @user.activated? || 
                                    !@user.authenticated?(:activation, token)

    flash.delete :danger
    if @user.digest_expired? :activated
      flash[:warning] = I18n.t 'flash.warning.link_expired'
      redirect_to root_path
    else
      flash[:success] = I18n.t 'flash.success.active_account'
      @user.active
      redirect_to user_path(@user.username)
    end
  end

  def send_active_mail
    @user = User.find_by username: params[:id]
    if validated_user? && !@user.activated?
      # 重新生成激活字段
      @user.generate_activation_digest
      AccountsMailer.active_account(@user).deliver
      flash[:info] = I18n.t "flash.info.validated_mail"
      redirect_to user_path(@user.username)      
    else 
      render_404
    end
  end

  private 
    def validated_user?
      return false if params[:id].nil? || !signed_in? || current_user != User.find_by(username: params[:id])
      true
    end
end
