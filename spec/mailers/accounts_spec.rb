require "rails_helper"

RSpec.describe AccountsMailer, type: :mailer do
  describe "active_account" do
    let(:mail) { AccountsMailer.active_account }

    xit "renders the headers" do
      expect(mail.subject).to eq("Active account")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
