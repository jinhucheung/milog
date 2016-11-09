require 'rails_helper'

RSpec.describe Article, type: :model do

  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
  let(:category) { Category.create name: "Test" }
  let(:article) { Article.new title: "Test", user: user, category: category }

  context "create" do
    it "success with valid information" do
      expect(article.valid?).to eq true
      expect{
        article.save
      }.to change { Article.all.size }.by 1
    end

    it "fail with no-title" do
      article.title = ""
      expect(article.valid?).to eq false
      expect(article.errors.include? :title).to eq true
      expect{
        article.save
      }.not_to change { Article.all.size }
    end

    it "fail with no-user" do
      article.user = nil
      expect(article.valid?).to eq false
      expect{
        article.save
      }.not_to change { Article.all.size }
    end

    it "fail with no-category" do
      article.category = nil
      expect(article.valid?).to eq false
      expect{
        article.save
      }.not_to change { Article.all.size }
    end

    it "should order by created_time desc" do
      one = Article.create title: "Test", user: user, category: category, created_at: Time.zone.now + 1.hours
      two = Article.create title: "Test", user: user, category: category, created_at: Time.zone.now + 2.hours
      three = Article.create title: "Test", user: user, category: category, created_at: Time.zone.now + 3.hours
      expect(Article.first).to eq three
      expect(Article.second).to eq two
      expect(Article.last).to eq one

      two.update_attribute :created_at, Time.zone.now + 4.hours
      expect(Article.first).to eq two.reload 
    end
  end
end