require 'rails_helper'

include SessionsHelper

RSpec.describe SessionsController, type: :controller do

  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw"}
  let(:session) { { session:{ email: user.email, password: user.password, remember_me: "0" } } }

  describe '#new' do
    it "should have new action" do
      get :new
      expect(response).to have_http_status :success
    end

    it "should render new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe '#create' do
    it "should raise error when receive nil params" do
      expect {
        post :create
      }.to raise_error
    end

    it "should find the user when valid sigin information" do 
      post :create, params: session 
      expect(response).to have_http_status :redirect
    end

    it "should get signed status when user successfully sign in" do 
      post :create, params: session 
      expect(response).to have_http_status :redirect
      expect(@request.signed_in?).to eq true
      expect(@request.current_user.email).to eq user.email 
    end

    it "should remember user when submit remember_me = 1" do 
      session[:session][:remember_me] = "1"
      post :create, params: session
      expect(@request.signed_in?).to eq true
      expect(@request.current_user.username).to eq user.username
      expect(remembered_me?).to eq true
    end

    it "shouldn't remember user when submit remember_me = 0 " do
      post :create, params: session
      expect(@request.signed_in?).to eq true
      expect(remembered_me?).to eq false
    end

    it "should render new when invalid email " do 
      session[:session][:email] = "Not" + user.email
      post :create, params: session, format: :js
      expect(response).to have_http_status :success
      expect(@request.test_signed_in?).to eq false
    end

    it "should render new when invalid password" do 
      session[:session][:password] = "Not" + user.password
      post :create, params: session, format: :js
      expect(response).to have_http_status :success
      expect(@request.test_signed_in?).to eq false
    end
  end

  describe '#destroy' do
    it "should redirect to root path" do 
      delete :destroy
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to root_path
    end

    it "signed_in? return false when sign out" do 
      post :create, params: session
      expect(@request.signed_in?).to eq true

      delete :destroy
      expect(@request.test_signed_in?).to eq false   
    end
  end
end
