require 'rails_helper'

RSpec.describe User, type: :model do

	let(:user) { User.new username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw" }

	describe "login format" do 
		context "when user is valid" do
			it { expect(user.valid?).to eq true }
		end

		context "when username is not present" do
			before { user.username = "" }
			it { expect(user.valid?).to eq false }
		end

		context "when username is not present" do
			before { user.username = "" }
			it { expect(user.valid?).to eq false }
		end

		context "when email is not present" do 
			before { user.email = "" }
			it { expect(user.valid?).to eq false }
		end

		context "when password is not present" do 
			before { user.password = user.password_confirmation = "" }
			it { expect(user.valid?).to eq false }
		end
	end


end
