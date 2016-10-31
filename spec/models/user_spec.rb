require 'rails_helper'

RSpec.describe User, type: :model do

	let(:user) { User.new username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw" }

	describe "login format" do 
		context "when user is valid" do
			it { expect(user.valid?).to eq true }
		end

		context "when username is valid" do
			it "username is aTestUser" do 
				user.username = "aTestUser"
				expect(user.valid?).to eq true
			end

			it "username is a_test-user" do
				user.username = "a_test-user"
				expect(user.valid?).to eq true
			end

			it "username is -00_testUser" do
				user.username = "-00_testUser"
				expect(user.valid?).to eq true
			end
		end

		context "when username is invalid" do 
			it "username is not present" do 
				user.username = ""
				expect(user.valid?).to eq false
			end

			it "username is too short" do 
				user.username = "a"*5
				expect(user.valid?).to eq false
			end
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
