class AccountsMailer < ApplicationMailer
  default from: 'no-reply@hijinhu.me'
    
  def active_account(user)
    @user = user
    mail to: user.email, subject: "Account active"
  end
end
