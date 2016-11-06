module UsersHelper
  def build_user(username, email, password)
    user = User.new username: username,
                    email: email,
                    password: password,
                    password_confirmation: password
  end

  # 返回大写的用户名首字母
  def firstchar_name(user)
    return "" if user.nil?
    user.username[0].upcase
  end

  def capitalize_name(user)
    return "" if user.nil?
    user.username.capitalize
  end

end
