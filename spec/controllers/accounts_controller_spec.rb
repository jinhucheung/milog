require 'rails_helper'

def user_params(user)
	{ user: { username: user.username, 
  					email: user.email, 
  					password: user.password, 
  					password_confirmation: user.password_confirmation } }
end

RSpec.describe AccountsController, type: :controller do

	let(:user) { User.new username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  describe '#new' do
    it "should have an new action" do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(:success)
    end

    it "renders th new template" do 
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do 
  	it "valid signup information" do 
  		expect{ 
				post :create, params: user_params(user)
  		}.to change{ User.count }.by(1)
  		expect(flash[:info]).not_to be_empty
      expect(response).not_to have_http_status(:success)
      expect(response).to have_http_status(:redirect)
  		expect(response).to redirect_to root_path
  	end

  	it "invalid signup information" do
  		expect {
  			user.username = "test@user"
  			post :create, params: user_params(user)
  			user.username = "aTestUser"
  			user.email = ""
  			post :create, params: user_params(user)

  			user.email = "aTestUser@test.com"
  			user.password_confirmation = ""
  			post :create, params: user_params(user)

  		}.not_to change{ User.count }
      expect(response).not_to have_http_status(:redirect)
  		expect(response).to render_template(:new)
  	end

  	it "invalid signup with account existed" do 
  		expect{ 
				post :create, params: user_params(user)
  		}.to change{ User.count }.by(1)
  		expect{
  			dup_user = user.dup
  			post :create, params: user_params(dup_user)

        dup_user.username = "not" + user.username
        post :create, params: user_params(dup_user)
        
        dup_user.username = user.username
        dup_user.email = "not" + user.email
        post :create, params: user_params(dup_user)     
  		}.not_to change { User.count }
      expect(response).not_to have_http_status(:redirect)
  		expect(response).to render_template(:new)
  	end

    it "valid signup has not error message" do 
      user.save
      expect(user.errors[:username]).to eq []
      expect(user.errors[:email]).to eq []
      expect(user.errors[:password]).to eq []
      expect(user.errors[:password_confirmation]).to eq []
    end

    it "invalid signup has error message" do
      user.save
      user.update_attributes username: "@"*7, email: "@"*7, password: "1", password_confirmation: "2"
      expect(user.errors[:username]).to be_any
      expect(user.errors[:email]).to be_any
      expect(user.errors[:password]).to be_any
      expect(user.errors[:password_confirmation]).to be_any
      expect(user.errors[:username]).to include(User::TIPS_USERNAME_FORMAT_MSG)
    end

  end

end
