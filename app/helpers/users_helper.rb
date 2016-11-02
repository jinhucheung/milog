module UsersHelper
  def buildUser(username, email, password)
    user = User.new username: username,
                    email: email,
                    password: password,
                    password_confirmation: password
  end

end
