require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { User.new username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  describe "login format" do
    context "when user is valid" do
      it { expect(user.valid?).to eq true }
    end

    context "when username is valid" do
      it "username = aTestUser" do
        user.username = 'aTestUser'
        expect(user.valid?).to eq true
      end

      it "username = a_test-user" do
        user.username = 'a_test-user'
        expect(user.valid?).to eq true
      end

      it "username = -00_testUser" do
        user.username = '-00_testUser'
        expect(user.valid?).to eq true
      end
    end

    context "when username is invalid" do
      it "username is not present" do
        user.username = ''
        expect(user.valid?).to eq false
      end

      it "username is too short" do
        user.username = 'a'*5
        expect(user.valid?).to eq false
      end

      it "username is too long" do
        user.username = 'a'*26
        expect(user.valid?).to eq false
      end

      it "username = test.user" do
        user.username = 'test.user'
        expect(user.valid?).to eq false
      end

      it "username = @@123-test" do
        user.username = '@@123-test'
        expect(user.valid?).to eq false
      end
    end

    it "username should be unique" do
      dup_user = user.dup
      dup_user.username.upcase!
      user.save
      expect(dup_user.valid?).to eq false
    end

    it "username should be lower-case" do
      upper_username = "ATESTUSER"
      user.username = upper_username
      user.save
      expect(upper_username.downcase).to eq user.reload.username
    end

    context "when email is valid" do
      it "email validation accept valid address" do
        valid_emails = 	%w(user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)
        valid_emails.each do | email |
          user.email = email
          expect(user.valid?).to eq true
        end
      end
    end

    context "when email is invalid" do
      it "email is not present" do
        user.email = ""
        expect(user.valid?).to eq false
      end

      it "email is too long" do
        user.email = "a"*244+"@example.com"
        expect(user.valid?).to eq false
      end

      it "email validation accept invalid address" do
        invalid_emails = %w(user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com)
        invalid_emails.each do | email |
          user.email = email
          expect(user.valid?).to eq false
        end
      end
    end

    it "email should be unique" do
      dup_user = user.dup
      dup_user.email.upcase!
      user.save
      expect(dup_user.valid?).to eq false
    end

    it "email should be lower-case" do
      upper_email = "ATESTUSER@TEST.COM"
      user.email = upper_email
      user.save
      expect(upper_email.downcase).to eq user.reload.email
    end

    context "when password is valid" do
      it "password confirmation match password" do
        user.password = user.password_confirmation = "hello&world"
        expect(user.valid?).to eq true
      end
    end

    context "when password is invalid" do
      it "password is not present" do
        user.password = user.password_confirmation = ""
        expect(user.valid?).to eq false
      end

      it "password is too short" do
        user.password = user.password_confirmation = "a"
        expect(user.valid?).to eq false
      end

      it "password confirmation don't match password" do
        user.password = "a"*6
        user.password_confirmation = "b"*6
        expect(user.valid?).to eq false
      end
    end
  end

  describe "User::Securable" do 
    it "should authenticate when token match digest" do 
      token = user.new_token
      digest = user.digest_token token
      expect(BCrypt::Password.new(digest).is_password?(token)).to eq true
    end

    it "shouldn't authenticate when token doesn't match digest" do 
      token = user.new_token
      digest = user.digest_token token 
      token = user.new_token
      expect(BCrypt::Password.new(digest).is_password?(token)).to eq false      
    end

    it "should authenticate when token match digest by #authenticated?" do
      token = user.new_token
      user.remember_digest = user.digest_token token
      expect(user.authenticated?(:remember, token)).to eq true   
    end

    it "shouldn't authenticate when token doestn't match digest by #authenticated?" do
      token = user.new_token
      user.remember_digest = user.digest_token token
      token = "1"
      expect(user.authenticated?(:remember, token)).to eq false        
    end

    context "digest is nil or blank" do
      it "shouldn't authenticate when remember_digest is nil or blank" do 
        user.remember_digest = nil
        expect {
          expect(user.authenticated?(:remember, "1")).to eq false
        }.not_to raise_error

        user.remember_digest = ""
        expect {
          expect(user.authenticated?(:remember, "1")).to eq false
        }.not_to raise_error
      end
    end
  end

  describe "digest helper methods" do 
    it "should get activation_token and activation_digest when call new_attr_digest(:activation)" do 
      user.new_attr_digest :activation
      expect(user.activation_token).not_to eq nil
      expect(user.activation_digest).not_to eq nil      
    end

    it "should get remember_token and remember_digest when call new_attr_digest(:remember)" do 
      user.new_attr_digest :remember
      expect(user.remember_token).not_to eq nil
      expect(user.remember_digest).not_to eq nil      
    end

    it "should get token = nil and digest =nil when when call del_attr_digest(:activation)" do 
      user.new_attr_digest :activation
      user.del_attr_digest :activation
      expect(user.activation_token).to eq nil
      expect(user.activation_digest).to eq nil           
    end

    it "should be expired when digest is generated in 2 hours ago" do
      user.save
      user.update_attribute :activated_at, Time.zone.now - 3.hours
      expect(user.digest_expired?(:activated)).to eq true
    end

    it "should be valid when digest is generated in 2 hours " do 
      user.save
      user.update_attribute :activated_at, Time.zone.now
      expect(user.digest_expired?(:activated)).to eq false

      user.update_attribute :activated_at, Time.zone.now - 30.minutes
      expect(user.digest_expired?(:activated)).to eq false

      user.update_attribute :activated_at, Time.zone.now - 1.5.hours
      expect(user.digest_expired?(:activated)).to eq false     
    end
  end

  context "avatar" do 
    it "should return false in user_avatar? when user create" do
      user.save
      expect(user.user_avatar?).to eq false
    end
  end

  describe "articles" do
    before :each do
      user.save
    end

    let(:category) { Category.create name: 'Test' }

    context "article" do
      it "should success when it create with valid information" do
        asize = user.articles.size
        expect {
         user.articles.create title: "Hello World", category: category
        }.to change { Article.all.size }.by(1)
        expect(user.articles.size - asize).to eq 1
      end

      it "should has existed with information when it create with valid information" do 
        user.articles.create title: "Hello World", category: category
        article = user.articles.first
        expect(article).not_to eq nil
        expect(article.title).to eq "Hello World"
        expect(article.category).to eq category       
      end

      it "should fail when it create with no-category" do
        expect {
          article = user.articles.create title: "Hello World", category: nil
          expect(article.valid?).to eq false
          expect(article.save).to eq false
          expect(article.errors.include? :category_id).to eq true
        }.not_to change { Article.all.size }
      end

      it "should fail when it create with no-title" do
        expect {
          article = user.articles.create title: "", category: category
          expect(article.valid?).to eq false
          expect(article.save).to eq false
          expect(article.errors.include? :title).to eq true
        }.not_to change { Article.all.size }
      end

      it "should order by created_time in desc" do
        article = user.articles.create title: "Hello", category: category
        brticle = user.articles.create title: "Hello", category: category
        crticle = user.articles.create title: "Hello", category: category

        expect(user.articles.first).to eq crticle
        expect(user.articles.second).to eq brticle
        expect(user.articles.last).to eq article

        brticle.update_attribute :created_at, Time.zone.now + 1.hours
        expect(user.articles.reload.first).to eq brticle

        articles = user.articles.reorder(nil)
        expect(articles.first).to eq article
        expect(articles.second).to eq brticle
        expect(articles.last).to eq crticle
      end

      it "should destroy when destroy user of article" do
        article = user.articles.create title: "Hello", category: category
        brticle = user.articles.create title: "Hello", category: category 
        
        expect(Article.all.size).to eq 2
        user.destroy
        expect(Article.all.size).to eq 0 
      end
    end
  end

  describe "user_categoryships" do
    before :each do
      user.save
    end

    let(:category) { Category.create name: 'Test' }

    it "should include user and category when create a user_categoryship" do
      expect {
        user.reload
        user.user_categoryships.create category: category
      }.to change { UserCategoryship.all.size }.by 1
      user.reload
      category.reload
      expect(category.users.include? user).to eq true
      expect(user.categories.include? category).to eq true
    end

    it "should destroy when user destroy" do
      ships = user.user_categoryships.create category: category
      expect{
        user.destroy
      }.to change { UserCategoryship.all.reload.size }.by -2
      expect(category.reload).not_to eq nil
      expect(UserCategoryship.all.reload.include? ships).to eq false
      expect(Category.all.reload.include? category).to eq true
    end

    it "should has default category when user create" do
      category = Category.find_or_create_by name: 'default'
      expect(user.categories.include? category).to eq true
    end
  end

  describe "user_tags" do
    before :each do
      user.save
    end

    let(:category) { Category.create name: 'Test' }

    it "user should have tags which user's posted article include tags" do
      expect(user.tags).to be_empty
      article = user.articles.create title: "Hello", category: category, posted: true
      article.str2tags "linux,web"
      expect(user.tags).to be_any
      tag = Tag.find_by name: "linux"
      expect(user.tags.include? tag).to eq true
      tag = Tag.find_by name: "web"
      expect(user.tags.include? tag).to eq true
    end

    it "user shouldn't have tags which user's no-posted article include tags" do
      expect(user.tags).to be_empty
      article = user.articles.create title: "Hello", category: category
      article.str2tags "linux,web"
      expect(user.tags).to be_empty
    end

    it "user shouldn't have tags which article isn't user" do
       other = User.create username: "aTestUser2", email: "aTestUser2@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" 
       article = other.articles.create title: "Hello", category: category, posted: true
       article.str2tags "linux,web"
       expect(user.tags).to be_empty
       tag = Tag.find_by name: "linux"
       expect(user.tags.include? tag).to eq false  
    end
  end

  describe "pictures" do
    before :each do 
      user.save
    end

    it "should be visited when user signed up" do
      expect(user.pictures).not_to eq nil
      expect(user.pictures).to be_empty
    end
  end

  describe "comment" do
    let(:category) { Category.create name: 'Test' }

    it "should be created with valid params" do
      user.save
      article = user.articles.create title: 'hi', category: category, posted: true
      expect {
        user.comments.create content: "hello", article: article
      }.to change { Comment.all.reload.size }.by 1
    end
  end

  context "resume" do
    it "should unique" do
      expect(user.resume).to eq nil
      user.save
      expect(user.reload.resume).not_to eq nil
      expect{
        Resume.create user: user
      }.not_to change { Resume.all.reload.size }
    end
  end

  context "hold" do
    it "has two with user created" do
      expect(user.holds).to be_empty
      user.save
      expect(user.holds.size).to eq 2
    end

    it "holdable_type should include Article and Resume" do
      user.save
      holdable_types = user.holds.map &:holdable_type
      expect(holdable_types.include? 'Article').to eq true
      expect(holdable_types.include? 'Resume').to eq true
    end

    it "should return hold object in type when call hold(type)" do
      user.save
      expect(user.hold :resume).to eq user.holds.where(holdable_type: 'Resume').first
      expect(user.hold :article).to eq user.holds.where(holdable_type: 'Article').first
    end
  end
end
