module SessionsHelper

  def sign_in(user)
    session[:username] = user.username
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    if username = session[:username]
      @current_user ||= User.find_by username: username 
    elsif username = cookies.signed[:username]
      user = User.find_by username: username
      return nil unless user
      if user.authenticated? :remember, cookies.signed[:remember_token]
         sign_in user
         @current_user = user
      end 
    end
    @current_user
  end

  def remember_me(user)
    user.new_attr_digest :remember
    cookies.permanent.signed[:remember_token] = user.remember_token
    cookies.permanent.signed[:username] = user.username
  end

  def forget_me(user)
    user.del_attr_digest :remember
    cookies.delete :remember_token
    cookies.delete :username
  end

  def remembered_me?
    !cookies['username'].nil? && !cookies['remember_token'].nil?
  end

  def sign_out
    return unless signed_in?
    session.delete :username
    forget_me @current_user
    @current_user = nil
  end

  # 存储原始请求地址
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_or(default)
    redirect_to ( session[:forwarding_url] || default )
    session.delete :forwarding_url
  end
end
