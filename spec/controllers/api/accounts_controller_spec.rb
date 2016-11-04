require 'rails_helper'

include SessionsHelper

RSpec.describe Api::AccountsController, type: :controller do 

  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
  let(:others) { User.create username: "aTestOthers", email: "aTestOthers@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  context "#active" do 
    it "should active with valid params and token when user isn't activated" do 
      expect(user.activated?).to eq false
      get :active, params: { id: user.username, token: user.activation_token }
      user.reload
      expect(user.activated?).to eq true
      expect(flash[:success]).not_to eq nil
    end

    it "activation digest is nil when user has activated" do 
      expect(user.activated?).to eq false
      get :active, params: { id: user.username, token: user.activation_token }
      user.reload
      expect(user.activated?).to eq true
      expect(user.activation_digest).to eq nil         
    end

    it "shouldn't active with invalid username when user isn't activated" do 
      expect(user.activated?).to eq false
      get :active, params: { id: "a"*6, token: user.activation_token } 
      user.reload
      expect(user.activated?).to eq false
      expect(flash[:success]).to eq nil
      expect(flash[:danger]).not_to eq nil
    end

    it "shouldn't active with invalid token when user isn't activated" do
      expect(user.activated?).to eq false
      get :active, params: { id: user.username, token: "Not" + user.activation_token } 
      user.reload
      expect(user.activated?).to eq false
      expect(flash[:success]).to eq nil
      expect(flash[:danger]).not_to eq nil
    end

    it "shouldn't active when user has activated" do
      user.update_attribute(:activated, true)
      user.reload
      expect(user.activated?).to eq true
      get :active, params: { id: user.username, token: user.activation_token }
      expect(flash[:success]).to eq nil
      expect(flash[:danger]).not_to eq nil
    end

    it "shouldn't active when this activation link has expired" do 
      expect(user.activated?).to eq false
      user.update_attribute :activated_at, Time.zone.now - 3.hours
      user.reload
      get :active, params: { id: user.username, token: user.activation_token }
      user.reload
      expect(user.activated?).to eq false
      expect(flash[:warning]).not_to eq nil             
    end
  end

  context "#send_active_mail" do 
    it "should render 404 when not find user" do
      get :send_active_mail, params: { id: "abcdtest"}     
      expect(response.status).to eq 404
    end

    it "should render 404 when user don't sign in" do
      expect(test_signed_in?).to eq false
      get :send_active_mail, params: { id: user.username}
      expect(response.status).to eq 404
    end

    it "should render 404 when current_user isn't need_send_mail user" do
      sign_in user
      expect(test_signed_in?).to eq true
      expect(current_user).to eq user
      get :send_active_mail, params: { id: others.username}
      expect(response.status).to eq 404
    end

    it "should render 404 when user has activated" do
      user.update_attribute(:activated, true)
      user.reload
      expect(user.activated?).to eq true
      sign_in user
      get :send_active_mail, params: { id: user.username}
      expect(response.status).to eq 404
    end

    it "should re-send activation mail when valid user" do
      expect(user.activated?).to eq false
      sign_in user
      get :send_active_mail, params: { id: user.username}
      expect(flash[:info]).to eq I18n.t "flash.info.validated_mail"
      expect(response.status).not_to eq 404 
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to user_path(user.username) 
    end
  end

end