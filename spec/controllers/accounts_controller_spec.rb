require 'rails_helper'

def user_params(user)
  { user: { username: user.username,
            email: user.email,
            password: user.password,
            password_confirmation: user.password_confirmation } }
end

def profile_params
  { user: { nickname: "kumho", email_public: "0", github: "hikumho", weibo: "u/123456",
            website: "hijinhu.me", bio: "Hello World" },
    by: '' }
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
      expect(response).to redirect_to user_path(user.username.downcase!)
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

  describe '#edit' do 
    it "should redirect to sign in path when user don't sign in" do
      get :edit
      expect(response).to redirect_to signin_path
      expect(response).not_to render_template :edit
    end

    it "should mark edit_account_url when user don't sign in" do
      get :edit
      expect(session[:forwarding_url]).to eq edit_account_url
    end

    it "should render edit template when user has signed in and activate" do 
      user.save
      sign_in user
      user.update_attribute :activated, true
      get :edit
      expect(response).to have_http_status :success
      expect(response).to render_template :edit
    end

    it "should redirect to root path when user has signed in but not activated" do
      user.save
      sign_in user
      get :edit
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to root_path
    end
  end

  describe '#update' do 
    before(:each) do
      user.save
    end

    let(:profile) { profile_params }
    let(:psw) { { user: { cur_psw: user.password, new_psw: "a"*7, new_psw_confirmation: "a"*7 }, by: "psw" } }
    let(:avatar) { { user:{}, by: 'avatar' } }

    it "should redirect to sign in path when user don't sign in" do
      patch :update, params: {}
      expect(response).to redirect_to signin_path
      expect(response).not_to render_template :edit      
    end

    it "should redirect to root path when user signed but not activated" do
      sign_in user
      patch :update, params: profile
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to root_path
      expect(flash[:warning]).not_to eq nil
    end

    context "update profile when user has signed in and activated" do
      before :each do 
        sign_in user
        user.update_attribute :activated, true
      end

      it "should has updated with valid information" do
        patch :update, params: profile
        expect(response).to have_http_status :success
        expect(response).to render_template :edit
        expect(flash[:success]).to eq I18n.t("flash.success.update_profile")
        expect(flash[:warning]).to eq nil

        user.reload
        expect(user.nickname).to eq "kumho"
        expect(user.email_public).to eq false
        expect(user.github).to eq "hikumho"
        expect(user.weibo).to eq "u/123456"
        expect(user.website).to eq "hijinhu.me"
        expect(user.bio).to eq "Hello World"
      end

      it "should strip link" do
        profile[:user][:github] = "  hikumho "
        profile[:user][:weibo] = "u/123456 "
        profile[:user][:website] = "  hijinhu.me"
        patch :update, params: profile
        user.reload
        expect(user.github).to eq "hikumho"
        expect(user.weibo).to eq "u/123456"
        expect(user.website).to eq "hijinhu.me"
      end

      it "shouldn't update profile with by=psw" do
        profile[:by] = 'psw'
        patch :update, params: profile
        expect(flash[:danger]).to eq I18n.t "flash.danger.params_invalid"
      end

      it "shouldn't update profile with by=avatar" do
        profile[:by] = 'avatar'
        patch :update, params: profile
        expect(flash[:danger]).to eq I18n.t "flash.danger.params_invalid"
      end

      it "shouldn't update profile with params[:by] invalid" do
        profile[:by] = 'z'
        patch :update, params: profile
        expect(flash[:danger]).to eq I18n.t "flash.danger.params_invalid"
      end
    end

    context "update password when user has signed in and activated" do
      before :each do 
        sign_in user
        user.update_attribute :activated, true
      end

      it "should update password with valid information" do
        patch :update, params: psw
        expect(response).to have_http_status :success
        expect(response).to render_template :edit
        expect(flash[:success]).to eq I18n.t("flash.success.reset_password")

        user.reload
        expect(user.authenticated?(:password, psw[:user][:new_psw])).to eq true
      end

      it "shouldn't update with current password not match" do
        psw[:user][:cur_psw] = "Not"+user.password
        patch :update, params: psw

        expect(flash[:success]).to eq nil

        user.reload
        expect(user.authenticated?(:password, psw[:user][:new_psw])).to eq false
        expect(user.authenticated?(:password, user.password)).to eq true
      end

      it "shouldn't update with new password invalid" do
        psw[:user][:new_psw] = "1"
        patch :update, params: psw

        expect(flash[:success]).to eq nil

        user.reload
        expect(user.authenticated?(:password, psw[:user][:new_psw])).to eq false
        expect(user.authenticated?(:password, user.password)).to eq true
      end

      it "shouldn't update with new password confirmation don't match" do
        psw[:user][:new_psw_confirmation] = "Not"+psw[:user][:new_psw]
        patch :update, params: psw

        expect(flash[:success]).to eq nil

        user.reload
        expect(user.authenticated?(:password, psw[:user][:new_psw])).to eq false
        expect(user.authenticated?(:password, user.password)).to eq true
      end

      it "shouldn't update with params[:by] invalid" do
        psw[:by] = nil
        patch :update, params: psw
        expect(flash[:danger]).to eq I18n.t "flash.danger.params_invalid"

        psw[:by] = "avatar"
        patch :update, params: psw
        expect(flash[:danger]).to eq I18n.t "flash.danger.params_invalid"

        psw[:by] = "hello"
        patch :update, params: psw
        expect(flash[:danger]).to eq I18n.t "flash.danger.params_invalid"
      end
    end

    context "update avatar when user has signed in and activated" do
      before :each do 
        sign_in user
        user.update_attribute :activated, true
      end

      let(:img) { fixture_file_upload('images/logo.png', 'image/png') }

      it "should has updated with valid avatar" do
        avatar[:user][:avatar] = img
        expect {
          patch :update, params: avatar
          user.reload
        }.to change { user.avatar.file }  
        expect(response).to have_http_status :success
        expect(response).to render_template :edit
        expect(flash[:success]).to eq I18n.t("flash.success.update_avatar")
      end

      it "shouldn't update with invalid avatar" do
        avatar[:user][:avatar] = "a"*7
        expect {
          patch :update, params: avatar
          user.reload
        }.not_to change { user.avatar.file }  
      end
    end
  end

end
