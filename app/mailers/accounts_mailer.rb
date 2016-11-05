class AccountsMailer < ApplicationMailer
  default from: 'hikumho@163.com'
  
  def active_account(user)
    @default_i18n = "accounts_mailer.active_account"
    @user = user
    mail to: user.email, subject: I18n.t("#{@default_i18n}.subject")
  end
end
