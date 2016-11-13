require 'rails_helper'

RSpec.describe ArticleTagship, type: :model do
  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
  let(:category) { Category.create name: "study" }
  let(:article) { Article.new title: "hello", user: user, category: category }
  let(:tag) { Tag.new name: 'linux' }

  it "should has error when article isn't presence" do
    tag.save
    ship = ArticleTagship.new article: article, tag: tag
    expect(ship.valid?).to eq false
    expect(ship.errors[:article_id]).to be_any
    expect(ship.errors[:tag_id]).to be_empty
  end

  it "should has error when tag isn't presence" do
    article.save
    ship = ArticleTagship.new article: article, tag: tag
    expect(ship.valid?).to eq false
    expect(ship.errors[:article_id]).to be_empty
    expect(ship.errors[:tag_id]).to be_any
  end

  it "should has error when tag and article aren't presence" do
    ship = ArticleTagship.new article: article, tag: tag
    expect(ship.valid?).to eq false
    expect(ship.errors[:article_id]).to be_any
    expect(ship.errors[:tag_id]).to be_any
  end

  it "should has created a ship when tag and article are presence" do
    article.save
    tag.save
    ship = ArticleTagship.new article: article, tag: tag
    expect(ship.valid?).to eq true
    expect(ship.errors[:article_id]).to be_empty
    expect(ship.errors[:tag_id]).to be_empty    
  end
end
