require 'rails_helper'

RSpec.describe Accounts::ActivationsController, type: :controller do 

  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
  let(:others) { User.create username: "aTestOthers", email: "aTestOthers@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  # 激活链接验证
  context "#edit" do 
    it "should active with valid params and token when user isn't activated" do 
      expect(user.activated?).to eq false
      get :edit, params: { id: user.username, token: user.activation_token }
      user.reload
      expect(user.activated?).to eq true
      expect(flash[:success]).not_to eq nil
    end

    it "activation digest is nil when user has activated" do 
      expect(user.activated?).to eq false
      get :edit, params: { id: user.username, token: user.activation_token }
      user.reload
      expect(user.activated?).to eq true
      expect(user.activation_digest).to eq nil         
    end

    it "shouldn't active with invalid username when user isn't activated" do 
      expect(user.activated?).to eq false
      get :edit, params: { id: "a"*6, token: user.activation_token } 
      user.reload
      expect(user.activated?).to eq false
      expect(flash[:success]).to eq nil
      expect(response.status).to eq 404
    end

    it "shouldn't active with invalid token when user isn't activated" do
      expect(user.activated?).to eq false
      get :edit, params: { id: user.username, token: "Not" + user.activation_token } 
      user.reload
      expect(user.activated?).to eq false
      expect(flash[:success]).to eq nil
      expect(response.status).to eq 404
    end

    it "shouldn't active when user has activated" do
      user.update_attribute(:activated, true)
      user.reload
      expect(user.activated?).to eq true
      get :edit, params: { id: user.username, token: user.activation_token }
      expect(flash[:success]).to eq nil
      expect(response.status).to eq 404
    end

    it "shouldn't active when this activation link has expired" do 
      expect(user.activated?).to eq false
      user.update_attribute :activated_at, Time.zone.now - 3.hours
      user.reload
      get :edit, params: { id: user.username, token: user.activation_token }
      user.reload
      expect(user.activated?).to eq false
      expect(flash[:warning]).not_to eq nil             
    end
  end

  # 重新发送激活链接
  context "#new" do 
    it "should render 404 with id when don't sign in" do
      get :new, params: { id: "abcdtest"}     
      expect(response.status).to eq 404
    end

    it "should render 404 when user don't sign in" do
      expect(test_signed_in?).to eq false
      get :new
      expect(response.status).to eq 404
    end

    it "should render 404 when current_user is nil" do
      sign_in user
      expect(test_signed_in?).to eq true
      expect(current_user).not_to eq nil
      sign_out
      expect(current_user).to eq nil      
      get :new
      expect(response.status).to eq 404
    end

    it "should render 404 when user has activated" do
      user.update_attribute(:activated, true)
      user.reload
      expect(user.activated?).to eq true
      sign_in user
      get :new
      expect(response.status).to eq 404
    end

    it "should re-send activation mail when valid user" do
      expect(user.activated?).to eq false
      sign_in user
      get :new
      expect(flash[:info]).to eq I18n.t "flash.info.validated_mail"
      expect(response.status).not_to eq 404 
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to user_path(user.username) 
    end
  end

end