require 'rails_helper'

RSpec.describe User, type: :model do

	let(:user) { User.new username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

	describe "login format" do
		context "when user is valid" do
			it { expect(user.valid?).to eq true }
		end

		context "when username is valid" do
			it "username = aTestUser" do 
				user.username = 'aTestUser'
				expect(user.valid?).to eq true
			end

			it "username = a_test-user" do
				user.username = 'a_test-user'
				expect(user.valid?).to eq true
			end

			it "username = -00_testUser" do
				user.username = '-00_testUser'
				expect(user.valid?).to eq true
			end
		end

		context "when username is invalid" do 
			it "username is not present" do 
				user.username = ''
				expect(user.valid?).to eq false
			end

			it "username is too short" do 
				user.username = 'a'*5
				expect(user.valid?).to eq false
			end

			it "username is too long" do 
				user.username = 'a'*26
				expect(user.valid?).to eq false
			end

			it "username = test.user" do
				user.username = 'test.user'
				expect(user.valid?).to eq false
			end

			it "username = @@123-test" do
				user.username = '@@123-test'
				expect(user.valid?).to eq false
			end
		end

		it "username should be unique" do 
				dup_user = user.dup
				dup_user.username.upcase!
				user.save
				expect(dup_user.valid?).to eq false
		end

		it "username should be lower-case" do 
				upper_username = "ATESTUSER"
				user.username = upper_username
				user.save
				expect(upper_username.downcase).to eq user.reload.username
		end

		context "when email is valid" do 
			it "email validation accept valid address" do 
				valid_emails = 	%w(user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn) 
				valid_emails.each do | email |
					user.email = email
					expect(user.valid?).to eq true
				end
			end
		end

		context "when email is invalid" do 
			it "email is not present" do 
				user.email = ""
				expect(user.valid?).to eq false
			end

			it "email is too long" do 
				user.email = "a"*244+"@example.com"
				expect(user.valid?).to eq false
			end

			it "email validation accept invalid address" do 
				invalid_emails = %w(user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com)
				invalid_emails.each do | email |
					user.email = email
					expect(user.valid?).to eq false
				end
			end
		end

		it "email should be unique" do 
				dup_user = user.dup
				dup_user.email.upcase!
				user.save
				expect(dup_user.valid?).to eq false
		end

		it "email should be lower-case" do 
				upper_email = "ATESTUSER@TEST.COM"
				user.email = upper_email
				user.save
				expect(upper_email.downcase).to eq user.reload.email
		end

		context "when password is valid" do 
			it "password confirmation match password" do 
				user.password = user.password_confirmation = "hello&world"
				expect(user.valid?).to eq true
			end
		end

		context "when password is invalid" do 
			it "password is not present" do 
				user.password = user.password_confirmation = ""
				expect(user.valid?).to eq false 
			end

			it "password is too short" do 
				user.password = user.password_confirmation = "a"
				expect(user.valid?).to eq false
			end

			it "password confirmation don't match password" do 
				user.password = "a"*6
				user.password_confirmation = "b"*6
				expect(user.valid?).to eq false
			end
		end
	end
	
end
