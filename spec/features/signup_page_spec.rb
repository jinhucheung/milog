require 'rails_helper'

def user_params(user)
  { user: { username: user.username,
            email: user.email,
            password: user.password,
            password_confirmation: user.password_confirmation } }
end

RSpec.describe "Signup Page", type: :feature do

  let(:user) { User.new username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  it "get this page" do
    visit signup_path
  end

  it "set locale in this page" do
    visit signup_path
    page.has_selector?("#locale_btn")
    # 切换语系至EN
    find("#locale_btn").click
    expect(I18n.locale).to eq :en
    expect(page).to have_selector("#locale_btn", text: "中文")
    # 切换语系至zh-CN
    find("#locale_btn").click
    expect(I18n.locale).to eq :"zh-CN"
    expect(page).to have_selector("#locale_btn", text: "EN")
  end


  it "should sign up with valid information" do
    visit signup_path
    expect(page).to have_selector(".under-line", text: I18n.t(:signup) )

    fill_in "user_username", with: user.username
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password_confirmation
    expect {
      click_button "signup"
    }.to change { User.count }.by(1)
    expect(page).to have_selector(".flash-alert", text: I18n.t("flash.info.validated_mail"))

  end

  it "shouldn't sign up with non-information" do
    visit signup_path
    expect(page).to have_selector(".under-line", text: I18n.t(:signup) )
    expect(page).not_to have_selector(".form-error-field")
    # 空信息注册
    expect {
      click_button "signup"
    }.not_to change { User.count }
    expect(page).to have_selector(".form-error-field")
    expect(page).not_to have_selector(".flash-alert", text: I18n.t("flash.info.validated_mail"))
  end

  it "shouldn't sign up with invalid username information" do
    visit signup_path
    fill_in "user_username", with: "@"*7
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password_confirmation
    expect {
      click_button "signup"
    }.not_to change { User.count }
    expect(page).to have_selector(".form-error-field")

    fill_in "user_username", with: "1"*5
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password_confirmation
    expect {
      click_button "signup"
    }.not_to change { User.count }
    expect(page).to have_selector(".form-error-field")
  end

  it "shouldn't sign up with invalid email information" do
    visit signup_path
    fill_in "user_username", with: user.username
    fill_in "user_email", with: "@"
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password_confirmation
    expect {
      click_button "signup"
    }.not_to change { User.count }
    expect(page).to have_selector(".form-error-field")
  end

  it "shouldn't sign up with invalid password " do
    visit signup_path
    fill_in "user_username", with: user.username
    fill_in "user_email", with: user.email
    fill_in "user_password", with: ""
    fill_in "user_password_confirmation", with: user.password_confirmation
    expect {
      click_button "signup"
    }.not_to change { User.count }
    expect(page).to have_selector(".form-error-field")
  end

  # 测试AccountsController#create的else部分
  # 当输入错误用户格式后,提示信息能根据I18n.locale正确显示
  # 之前遇到的情况时,提示信息后再切换语系,之后显示提示信息是之前I18n.locale的
  # @see Model/User中validates :username 与 AccountsController#create
  it "should show errors message with I18n.locale when sign up with invalid username format" do
    error_message = I18n.t("errors.username_format")
    visit signup_path
    fill_in "user_username", with: "@"*7
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password_confirmation
    click_button "signup"
    expect(page).to have_selector(".form-error-field", text: error_message )

    find("#locale_btn").click
    fill_in "user_username", with: "@"*7
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password_confirmation
    click_button "signup"
    expect(page).not_to have_selector(".form-error-field", text: error_message )
  end

end
