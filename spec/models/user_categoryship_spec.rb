require 'rails_helper'

RSpec.describe UserCategoryship, type: :model do
  let(:category) { Category.new name: "Test" }
  let(:user) { User.new username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  it "shouldn't create when user and category aren't existed" do
    expect {
      ship = UserCategoryship.create user: user, category: category
    }.not_to change { UserCategoryship.all.reload.size }
  end

  it "shouldn't create when user is existed" do
    category.save
    expect {
      ship = UserCategoryship.create user: user, category: category
    }.not_to change { UserCategoryship.all.reload.size }
  end

  it "shouldn't create when category is existed" do
    user.save
    expect {
      ship = UserCategoryship.create user: user, category: category
    }.not_to change { UserCategoryship.all.reload.size }
  end

  it "should create when user and category have existed" do
    user.save
    category.save
    expect {
      ship = UserCategoryship.create user: user, category: category
    }.to change { UserCategoryship.all.reload.size }.by 1
  end
end
