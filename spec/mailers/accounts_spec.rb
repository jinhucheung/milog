require "rails_helper"

RSpec.describe AccountsMailer, type: :mailer do
  describe "active_account" do
    let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
    let(:mail) { AccountsMailer.active_account user }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("accounts_mailer.active_account.subject"))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Setting.support_email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.username)
    end
  end

end
