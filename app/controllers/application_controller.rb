class ApplicationController < ActionController::Base
  include UsersHelper, SessionsHelper

  protect_from_forgery with: :exception
  before_action :set_locale, :set_time_zone

  # 设置语系
  def set_locale
    supported_locale = %w(zh-CN en)
    if params[:locale] && I18n.locale_available?( params[:locale].to_sym ) && supported_locale.include?( params[:locale] )
      cookies.permanent[:locale] = params[:locale]
    end
    I18n.locale = cookies[:locale] || I18n.default_locale
  end

  # 设置时区
  def set_time_zone
    Time.zone = 'Beijing'
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
    end
  end

  # 确保已登录, 否则转向登录页面
  def check_signed_in
    unless signed_in?
      store_location
      flash[:warning] = I18n.t "flash.warning.need_sign_in"
      redirect_to signin_path
    end
  end

  # 确保用户已验证, 否则重发验证邮件
  def check_activated
    return if current_user.blank?
    unless current_user.activated?
      store_location
      pre = I18n.t 'flash.warning.need_activation'
      pro_link = "#{view_context.link_to I18n.t('flash.warning.send_validation_mail'), new_accounts_activation_path}"
      flash[:warning] = pre + I18n.t('syml.dot') + pro_link
      redirect_to root_path
    end
  end

  # 检查访问用户是否禁用
  def check_disabled_user
    user = User.find_by username: params[:id]
    return render_404 if user.blank? || user.disabled?
  end

  # 确保用户是管理员
  def check_admin
    return render_404 if current_user.blank? || !current_user.admin?
  end

  def authenticate_user!
    render_404 unless signed_in?
  end
end
