require 'rails_helper'


RSpec.describe 'Category Widget', type: :feature do 


  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  context "should redirect when user not sign in or activate" do
    it "redirect to sign in path when user not sign in" do
      visit new_article_path
      expect(page).to have_current_path signin_path
      expect(page).to have_content I18n.t("flash.warning.need_sign_in")
    end

    it "redirect to send valid email when user not activate" do
      visit signin_path
      fill_in "session_email", with: user.email
      fill_in "session_password", with: user.password
      click_button "signin"

      visit new_article_path
      expect(page).to have_content I18n.t('flash.warning.need_activation')
    end
  end

  context "when user signed_in and activated" do
    before :each do 
      visit signin_path
      fill_in "session_email", with: user.email
      fill_in "session_password", with: user.password
      click_button "signin"

      user.update_attribute :activated, true
    end

    let(:category) { user.categories.create name: 'Hello' }

    xcontext "#create" do
      it "should render success when user submit valid category name" do
        expect(user.categories.where name: "test").to be_empty

        visit new_article_path
        find("#categories-dropdown").click
        find("#category-item-add").set "test"

        user.categories.reload
        expect(user.categories.where name: "test").not_to be_empty
      end
    end
  end

end