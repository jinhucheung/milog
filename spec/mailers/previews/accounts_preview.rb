# Preview all emails at http://localhost:3000/rails/mailers/accounts
class AccountsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/accounts/active_account
  def active_account
    AccountsMailer.active_account
  end

end
