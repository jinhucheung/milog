class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale


  def set_locale
  	# 设置语系
  	supported_locale = %w(zh-CN en)
  	if params[:locale] && I18n.locale_available?( params[:locale].to_sym ) && supported_locale.include?( params[:locale] )
  	  cookies.permanent[:locale] = params[:locale]
  	end
  	I18n.locale = cookies[:locale] || I18n.default_locale
  end
end
