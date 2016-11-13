require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { Tag.new name: "test" }

  context "#create" do
    it "should has error with name is nil" do
      tag.name = ""
      expect(tag.save).to eq false
      expect(tag.errors[:name]).not_to eq nil
    end

    it "should has created with name is valid" do
      expect(tag.save).to eq true
    end

    it "name should downcase when tag has created" do
      tag.name = "TEst"
      tag.save
      expect(tag.reload.name).to eq "test"
    end

    it "name should strip when tag has created" do
      tag.name = "  test "
      tag.save
      expect(tag.reload.name).to eq "test"
    end

    it "should has error when database has same name" do
      tag.save
      newTag = Tag.new name: tag.name
      expect(newTag.save).to eq false
      expect(newTag.errors[:name]).not_to eq nil
    end
  end

  context "#article_tagships" do
    before :each do 
      tag.save
    end

    let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
    let(:category) { Category.create name: "linux" }
    let(:article) { Article.create title: "hello", user: user, category: category }

    it "should get article_tagship" do
      expect(tag.article_tagships).not_to eq nil
      expect(tag.article_tagships).to be_empty
    end

    it "should get articles" do
      expect(tag.articles).not_to eq nil
      expect(tag.articles).to be_empty
    end

    it "should has a ship when create a article_tagship" do
      tag.article_tagships.create article: article
      tag.article_tagships.reload
      expect(tag.article_tagships).to be_any
    end

    it "should has a ship when create a article" do
      tag.articles.create title: "hello", user: user, category: category
      tag.articles.reload
      expect(tag.articles).to be_any      
    end
  end
end
