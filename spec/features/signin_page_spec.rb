require 'rails_helper'

RSpec.describe "Signin Page", type: :feature do 

  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw"}

  it "get this page" do 
    visit signin_path
  end

  it "should render this page" do 
    visit signin_path
    expect(page).to have_selector(".under-line", text: I18n.t(:signin) )
  end

  it "should sign in with valid information " do 
    visit signin_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_button "signin"
    expect(page).to have_current_path user_path(user.username)
  end

  it "should visit root_path when user signed in" do 
    visit signin_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password

    click_button "signin"

    visit root_path
    expect(page).to have_current_path root_path
    expect(page).to have_content(I18n.t('signed_in')) 
  end

  it "should render this page with invalid password" do 
    visit signin_path

    fill_in "session_email", with: user.email
    fill_in "session_password", with: ""

    click_button "signin"
    expect(page).to have_current_path signin_path
    expect(page).to have_selector(".form-error-field")     
  end

  it "should render this page with invalid email" do 
    visit signin_path

    fill_in "session_email", with: ""
    fill_in "session_password", with: user.password

    click_button "signin"
    expect(page).to have_current_path signin_path
    expect(page).to have_selector(".form-error-field")     
  end

  it "should visit root_path not include signed_in text when user not sign in" do 
    visit signin_path

    fill_in "session_email", with: ""
    fill_in "session_password", with: user.password

    click_button "signin"

    visit root_path
    expect(page).to have_current_path root_path
    expect(page).not_to have_content(I18n.t('signed_in')) 
  end

end