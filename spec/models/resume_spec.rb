require 'rails_helper'

RSpec.describe Resume, type: :model do
  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  context "#create" do
    it "should have a user" do
      expect {
        r = Resume.create
        expect(r.errors.include? :user_id).to eq true
      }.not_to change { Resume.all.reload.size }
    end

    it "user only have a resume" do
      expect {
        Resume.create user: user
      }.to change { Resume.all.reload.size }.by 1
      expect(user.resume).not_to eq nil

      expect {
        r = Resume.create user: user
        expect(r.errors.include? :user_id).to eq true
      }.not_to change { Resume.all.reload.size }
    end
  end
end
