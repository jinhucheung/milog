require 'rails_helper'

include SessionsHelper

RSpec.describe "Sessions", type: :request do

  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw"}
  let(:session) { { session:{ email: user.email, password: user.password, remember_me: "0" } } }

  context "sign in" do
    it "sign in with valid information, sign out in last" do
      get "/signin"
      expect(response).to have_http_status :success
      expect(response).to render_template :new

      post '/signin', params: session
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to user_path user.username
      follow_redirect!
      expect(response.body).to match user.username
      expect(response.body).not_to match "@"*8
      expect(@request.signed_in?).to eq true

      get '/'
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to user_path user.username
      follow_redirect!
      expect(@request.signed_in?).to eq true

      delete '/signout'
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to root_path
      follow_redirect!
      expect(@request.test_signed_in?).to eq false

      get '/'
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
      follow_redirect!
      expect(response).to render_template :new
    end

    it "sign in with remember_me" do
      session[:session][:remember_me] = "1"
      post '/signin', params: session
      follow_redirect!
      expect(@request.signed_in?).to eq true
      expect(@request.remembered_me?).to eq true
    end

    it "sign in without remember_me" do
      post '/signin', params: session
      follow_redirect!
      expect(@request.signed_in?).to eq true
      expect(@request.remembered_me?).to eq false
    end

    it "shouldn't sign in with invalid email" do
      get "/signin"
      expect(response).to have_http_status :success
      expect(response).to render_template :new

      session[:session][:email] = "@"*7
      post '/signin', params: session
      expect(response).not_to have_http_status :redirect
      expect(response).to render_template :new
      expect(response.body).to match /form-error-field/
      expect(@request.test_signed_in?).to eq false
    end

    it "shouldn't sign in with password not match" do
      get "/signin"
      expect(response).to have_http_status :success
      expect(response).to render_template :new

      session[:session][:password] = "Not" + user.password
      post '/signin', params: session
      expect(response).not_to have_http_status :redirect
      expect(response).to render_template :new
      expect(response.body).to match /form-error-field/
      expect(@request.test_signed_in?).to eq false
    end
  end

  context "sign out" do
    it "should sign out when delete /signout" do
      post '/signin', params: session
      follow_redirect!
      expect(@request.signed_in?).to eq true

      delete '/signout'
      follow_redirect!
      expect(@request.test_signed_in?).to eq false     
    end
  end
end
