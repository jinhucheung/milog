require 'rails_helper'

def user_params(user)
	{ user: { username: user.username, 
  					email: user.email, 
  					password: user.password, 
  					password_confirmation: user.password_confirmation } }
end

RSpec.describe AccountsController, type: :controller do

	let(:user) { User.new username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  describe ':new' do
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

  describe ':create' do 
  	it "valid signup information" do 
  		expect{ 
				post :create, params: user_params(user)
  		}.to change{ User.count }.by(1)
  		expect(flash[:info]).not_to be_empty
  		expect(response).to redirect_to signup_path
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
  		expect(response).to render_template(:new)
  	end

  	it "invalid signup with account existed" do 
  		expect{ 
				post :create, params: user_params(user)
  		}.to change{ User.count }.by(1)
  		expect{
  			dup_user = user.dup 
  			dup_user.password = dup_user.password_confirmation = "123456"
  			post :create, params: user_params(dup_user)
  		}.not_to change { User.count }
  		expect(response).to render_template(:new)
  	end

  end

end
