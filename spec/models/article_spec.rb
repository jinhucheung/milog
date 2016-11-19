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

  context "tag" do
    before :each do
      article.save
    end

    it "should return blank when call #tags2str with no tags" do
      expect(article.tags).to be_empty
      expect(article.tags2str).to eq ""
    end

    it "should save tags to database when call #str2tags with no-blank" do
      tagstr = "hello,rails"
      article.str2tags tagstr
      expect(article.tags.reload).to be_any
      expect(article.tags.where name: 'hello').to be_any
      expect(article.tags.where name: 'rails').to be_any
      expect(article.tags.where name: 'test').to be_empty
    end

    it "should has error when self.tagstr with greater 5 tags" do
      expect(article.valid?).to eq true
      article.tagstr = "hello,"*6
      expect(article.valid?).to eq false
      expect(article.errors[:tag]).to include I18n.t("errors.tags_too_much", size: 5)
    end

    it "tag_ship should has destroy when article destroy" do
      tagstr = "hello,rails"
      article.str2tags tagstr
      tag = article.tags.first
      expect(ArticleTagship.where article: article, tag: tag).to be_any
      article.destroy
      expect(ArticleTagship.where article: article, tag: tag).to be_empty
      expect(Tag.where id: tag.id).to be_any   
    end
  end

  context "search" do
    it "article should be searchable" do
      size = Article.search_by_token_in_user("hi", user).size
      expect(size).to eq 0
    end
  end

  context "comment" do
    it "should be created with valid params" do
      article.save
      article.update_attribute :posted, true
      expect {
        article.comments.create content: "hello", user: user
      }.to change { Comment.all.reload.size }.by 1
    end

    it "should order by index in asc" do
      article.save
      article.update_attribute :posted, true
      c1 = article.comments.create content: "hello", user: user
      c2 = article.comments.create content: "hello", user: user    
      c3 = article.comments.create content: "hello", user: user
      expect(c1.index).to eq 1       
      expect(c2.index).to eq 2     
      expect(c3.index).to eq 3     
    end
  end
end