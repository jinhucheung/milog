class AccountsMailer < ApplicationMailer
  default from: 'hikumho@163.com'
  
  def active_account(user, password = nil)
    @default_i18n = "accounts_mailer.active_account"
    @user, @password = user, password
    mail to: user.email, subject: I18n.t("#{@default_i18n}.subject")
  end

  def reset_password(user)
    @default_i18n = "accounts_mailer.reset_password"
    @user = user
    mail to: user.email, subject: I18n.t("#{@default_i18n}.subject")
  end
end
