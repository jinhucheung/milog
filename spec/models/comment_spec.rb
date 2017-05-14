require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  let(:user) { User.create username: 'testuser', email: 'testuser@test.com', password: '123456', password_confirmation: "123456" }
  let(:category) { Category.create name: 'test' }
  let(:article) { user.articles.create title: "hello", category: category }

  context "create" do
    it "should be created with valid params" do
      article.update_attribute :posted, true
      expect {
        Comment.create content: "hi comment", article: article, index: 1, user: user
      }.to change { Comment.all.reload.size }.by 1
    end


    it "should create with failure with non-posted article" do
      expect {
        Comment.create content: "hi comment", article: article, index: 1, user: user
      }.not_to change { Comment.all.reload.size }      
    end

    it "should create with failure with non-content" do
      expect {
        Comment.create content: "", article: article, index: 1, user: user
      }.not_to change { Comment.all.reload.size }
    end

    it "should create with failure with non-article" do
      expect {
        Comment.create content: "hi comment ", article_id: nil, index: 1, user: user
      }.not_to change { Comment.all.reload.size }
    end

    it "should create with failure with non-index" do
      expect {
        Comment.create content: "hi comment ", article: article, index: nil, user: user
      }.not_to change { Comment.all.reload.size }
    end

    it "should create with failure with non user" do
      expect {
        c = Comment.create content: "hi comment ", article: article, index: 1
        expect(c.errors[:user_id].size).not_to eq 0
      }.not_to change { Comment.all.reload.size }
    end

    it "should auto calculate index in created time" do
      article.update_attribute :posted, true
      c1 = Comment.create content: "hi comment", article: article, user: user
      c2 = Comment.create content: "hi comment", article: article, user: user
      expect(c1.index).to eq 1
      expect(c2.index).to eq 2
    end

    it "should sort by index in asc when delete any" do
      article.update_attribute :posted, true
      c1 = Comment.create content: "hi comment", article: article, user: user
      c2 = Comment.create content: "hi comment", article: article, user: user
      c3 = Comment.create content: "hi comment", article: article, user: user
      c4 = Comment.create content: "hi comment", article: article, user: user
      c3.destroy
      expect(Comment.second).to eq c2
      expect(Comment.third).to eq c4
      c5 = Comment.create content: "hi comment", article: article, user: user
      expect(c4.index + 1).to eq c5.index            
    end
  end

  context "reply" do
    let(:posted_article) { user.articles.create title: "hello", category: category, posted: true }
    let(:comment) { Comment.create user: user, article: posted_article, content: "test" }

    it "should have this relationships" do
      expect(comment.replys.size).to eq 0
    end

    it "should have 2 record with replying comment in 2 times" do
      expect {
        comment.replys.create user: user, article: posted_article, content: 'test'
        comment.replys.create user: user, article: posted_article, content: 'test'
      }.to change { comment.replys.reload.size }.by 2
    end

    it "should have same article with parent comment" do
      reply = comment.replys.create user: user, content: 'test'
      expect(reply.article).to eq comment.article 
    end

  end
end
