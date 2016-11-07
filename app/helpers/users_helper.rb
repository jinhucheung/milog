module UsersHelper
  include Users::AvatarHelper

  def build_user(username, email, password)
    user = User.new username: username, email: email,
                    password: password, password_confirmation: password
  end

  def capitalize_name(user)
    return "" if user.blank?
    user.username.capitalize
  end

end
