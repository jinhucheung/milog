require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { Category.new name: "Test" }
  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  it "should create successfully with valid information" do
    expect{
      category.save
    }.to change{ Category.all.size }.by 1
  end

  it "shouldn't create when category name has existed" do
    category.save
    expect{
      a_category = Category.create name: "tesT"
      expect(a_category.errors.include? :name).to eq true
    }.not_to change { Category.all.size }
  end

  it "shouldn't create when category name with too length" do
    category.name = "T"*8
    expect(category.valid?).to eq true
    category.name = "T"*9
    expect(category.valid?).to eq false
    category.name = "中"*8
    expect(category.valid?).to eq true
  end

  it "should find this article when article with category" do
    category.save
    expect {
      article = user.articles.create title: "Hello", category: category
      expect(category.articles.reload.first).to eq article
    }.to change { category.articles.size }.by 1
  end

  it "should order by id in asc" do
    one = category.save
    two = Category.create name:  "A"*6
    expect(Category.first.name).to eq "test"
    expect(Category.second.name).to eq "a"*6
  end

  describe "user_categoryships" do
    before :each do
      category.save
    end

    it "should include user and category when create a user_categoryship" do
      expect {
        category.user_categoryships.create user: user
      }.to change { UserCategoryship.all.size }.by 2
      user.reload
      category.reload
      expect(category.users.include? user).to eq true
      expect(user.categories.include? category).to eq true
    end

    it "should destroy when category destroy" do
      ships = category.user_categoryships.create user: user
      expect{
        category.destroy
      }.to change { UserCategoryship.all.reload.size }.by -1
      expect(user.reload).not_to eq nil
      expect(UserCategoryship.all.reload.include? ships).to eq false
      expect(User.all.reload.include? user).to eq true
    end

  end
end
