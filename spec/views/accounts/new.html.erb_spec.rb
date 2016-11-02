require 'rails_helper'

RSpec.describe "accounts/new.html.erb", type: :view do

  before(:all) do
    @user = User.new
  end

  it "should render signup page" do
    render
  end

  it "should render signup page with errors message" do
    @user = User.create username: "", email: "", password: "", password_confirmation: ""
    render
    expect(rendered).to match /form-error-field/
  end

  it "should render signup page without errors message" do
    @user = User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw"
    render
    expect(rendered).not_to match /form-error-field/
  end

  it "should render partial _login_layout" do
    render
    expect(rendered).to render_template(partial: "_login_layout")
  end

  it "should render partial _signin_form" do
    render
    expect(rendered).to render_template(partial: "_signin_form")
  end

  it "should render partial _signup_form" do
    render
    expect(rendered).to render_template(partial: "_signup_form")
  end
end
