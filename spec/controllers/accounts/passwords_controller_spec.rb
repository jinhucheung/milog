require 'rails_helper'

RSpec.describe Accounts::PasswordsController, type: :controller do 
  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw"}
  let(:forgot) { { forgot: { email: user.email } } }

  # 重置密码请求 输入邮箱表单
  context "#new" do
    it "should have new action and render :new template" do 
      get :new
      expect(response).to render_template :new
    end
  end

  # 发送重置密码链接邮件
  context "#create" do 
    it "should have create action" do
      post :create, params: forgot
    end

    it "should send reset_password_link when email is valid(existed)" do 
      post :create, params: forgot
      user.reload
      expect(user.reset_password_digest).not_to eq nil 
      expect(user.reset_password_at).not_to eq nil        
      expect(flash[:info]).to eq I18n.t "flash.info.psw_reset_mail"
      expect(response).to render_template :new
    end

    it "shouldn't send reset_password_link when email is empty" do 
      forgot[:forgot][:email] = ""
      post :create, params: forgot
      expect(flash[:info]).to eq nil
      expect(response).to render_template :new
    end

    it "shouldn't send reset_password_link when email isn't found" do 
      forgot[:forgot][:email] = "Not" + user.email
      post :create, params: forgot
      expect(flash[:info]).to eq nil
      expect(response).to render_template :new      
    end

    it "shouldn't send reset_password_link when email format is invalid" do
      forgot[:forgot][:email] = "brebab@bbre"
      post :create, params: forgot
      expect(flash[:info]).to eq nil
      expect(response).to render_template :new                
    end
  end

  # 访问重置密码页面
  context "#edit" do
    it "should have edit action" do 
      get :edit, params: { id: user.username }
    end

    it "should render 404 when params hasn't token" do 
      get :edit, params: { id: user.username }
      expect(response.status).to eq 404
    end 

    it "should render 404 when not find user" do
      get :edit, params: { id: "Not_User", token: "b4" }
      expect(response.status).to eq 404
    end

    it "should render 404 when token is invalid" do
      user.generate_reset_password_digest
      get :edit, params: { id: user.username, token: "b4" }
      expect(response.status).to eq 404
    end

    it "should redirect_to root_path when token has been expired" do
      user.generate_reset_password_digest
      user.update_attribute :reset_password_at, Time.zone.now - 3.hours
      get :edit, params: { id: user.username, token: user.reset_password_token }
      expect(flash[:warning]).to eq I18n.t 'flash.warning.link_expired'
      expect(response).to redirect_to root_path
    end

    it "should render edit template when params is valid" do 
      user.generate_reset_password_digest
      get :edit, params: { id: user.username, token: user.reset_password_token }
      expect(response.status).not_to eq 404
      expect(flash[:warning]).to eq nil
      expect(response).to have_http_status :success
      expect(response).to render_template :edit
    end
  end

  # 更新密码
  context "#update" do
    it "should have create action" do 
      patch :update, params: { id: user.username }
    end

    it "should render 404 when params hasn't token" do 
      patch :update, params: { id: user.username }
      expect(response.status).to eq 404
    end 

    it "should render 404 when not find user" do
      patch :update, params: { id: "Not_User", token: "b4" }
      expect(response.status).to eq 404
    end

    it "should render 404 when token is invalid" do
      user.generate_reset_password_digest
      patch :update, params: { id: user.username, token: "b4" }
      expect(response.status).to eq 404
    end

    it "should redirect_to root_path when token has been expired" do
      user.generate_reset_password_digest
      user.update_attribute :reset_password_at, Time.zone.now - 3.hours
      patch :update, params: { id: user.username, token: user.reset_password_token }
      expect(flash[:warning]).to eq I18n.t 'flash.warning.link_expired'
      expect(response).to redirect_to root_path
    end

    it "should re-render edit template when password is empty" do 
      user.generate_reset_password_digest
      patch :update, params: { id: user.username, token: user.reset_password_token, 
                           user: { password: "", password_confirmation: "" } }
      expect(response).to render_template :edit
    end

    it "should re-render edit template when password is too-short" do 
      user.generate_reset_password_digest
      patch :update, params: { id: user.username, token: user.reset_password_token, 
                           user: { password: "1"*5, password_confirmation: "1"*5 } }
      expect(response).to render_template :edit
    end

    it "should re-render edit template when password_confirmation don't match" do 
      user.generate_reset_password_digest
      patch :update, params: { id: user.username, token: user.reset_password_token, 
                           user: { password: "1"*7, password_confirmation: "2"*7 } }
      expect(response).to render_template :edit
    end

    it "should reset password when params is valid" do
      new_psw = "1"*7 
      user.generate_reset_password_digest
      expect {
        patch :update, params: { id: user.username, token: user.reset_password_token, 
                           user: { password: new_psw, password_confirmation: new_psw } }
        user.reload
      }.to change{ user.password_digest }
      expect(flash[:info]).to eq I18n.t "flash.success.reset_password"
      expect(response).to redirect_to signin_path
      expect(user.reset_password_digest).to eq nil
    end
  end
end