require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
  let(:other) { User.create username: "aTestUser2", email: "aTestUser2@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }
  let(:category) { Category.create name: 'Test' }
  let(:article) { Article.create title: "Hello", user: user, category: category }

  context "#index" do
    it "should redirect to sign in path when user no sign in" do
      get :index, id: 1
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
      expect(flash[:warning]).to include I18n.t("flash.warning.need_sign_in")
    end

    it "should redirect to root path when user no active" do
      sign_in user
      get :index, id: 1
      expect(response).to redirect_to root_path
      expect(flash[:warning]).to include I18n.t('flash.warning.need_activation')
    end

    it "should redirect to signed user path" do
      sign_in user
      user.update_attribute :activated, true
      get :index
      expect(response).to redirect_to user_path(user.username)
    end
  end

  context "#show" do
    it "should render 404 when article non find" do
      article = Article.find_by_id 100
      expect(article).to eq nil
      get :show, id: 100
      expect(response).to have_http_status 404
    end

    it "should render 404 when article isn't posted" do
      expect(Article.all.include? article).to eq true
      get :show, id: article.id
      expect(response).to have_http_status 404
    end

    it "should render this article when article has posted" do
      article.update_attribute :posted, true
      get :show, id: article.id
      expect(response).to render_template :show
    end

    it "should render this article when user is owner of article which isn't posted" do
      sign_in user
      expect(article.user).to eq user
      expect(article.posted).to eq false
      get :show, id: article.id
      expect(response).to render_template :show
    end

    it "should view count + 1 when visit posted-article" do
      article.update_attribute :posted, true
      expect{
        get :show, id: article.id
      }.to change { article.reload.view_count }.by 1
    end
  end

  context "#new" do
    it "should redirect to sign in path when user no sign in" do
      get :new
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
      expect(flash[:warning]).to include I18n.t("flash.warning.need_sign_in")
    end

    it "should redirect to root path when user no active" do
      sign_in user
      get :new
      expect(response).to redirect_to root_path
      expect(flash[:warning]).to include I18n.t('flash.warning.need_activation')
    end

    it "should render new when user signed in and activated" do
      sign_in user
      user.update_attribute :activated, true
      get :new
      expect(response).to render_template :new
    end
  end

  context "#edit" do    
    it "should redirect to sign in path when user no sign in" do
      get :edit, id: article.id
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
      expect(flash[:warning]).to include I18n.t("flash.warning.need_sign_in")
    end

    it "should redirect to root path when user no active" do
      sign_in user
      get :edit, id: article.id
      expect(response).to redirect_to root_path
      expect(flash[:warning]).to include I18n.t('flash.warning.need_activation')
    end

    it "should render 404 when current_user isn't owner of article" do
      sign_in other
      other.update_attribute :activated, true
      get :edit, id: article.id
      expect(response).to have_http_status 404
    end

    it "should render edit with correct user" do
      sign_in user
      user.update_attribute :activated, true
      get :edit, id: article.id
      expect(response).to render_template :edit
    end
  end

  context "#create" do
    it "should redirect to sign in path when user no sign in" do
      post :create, article: {title: "Test", category_id: category.id, save: 1}
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
      expect(flash[:warning]).to include I18n.t("flash.warning.need_sign_in")
    end

    it "should redirect to root path when user no active" do
      sign_in user
      post :create, article: {title: "Test", category_id: category.id, save: 1}
      expect(response).to redirect_to root_path
      expect(flash[:warning]).to include I18n.t('flash.warning.need_activation')
    end

    it "should save article with valid user / title / category" do
      sign_in user
      user.update_attribute :activated, true
      expect {
        post :create, article: {title: "Test", category_id: category.id, save: 1}, format: :js       
      }.to change { user.articles.reload.size }.by 1
    end

    it "should article posted eq false when save article" do
      sign_in user
      user.update_attribute :activated, true
      article.save
      expect(user.articles.reload.first).to eq article
      post :create, article: {title: "Test", category_id: category.id, save: 1}, format: :js
      expect(user.articles.reload.first).not_to eq article
      expect(user.articles.reload.first.posted).to eq false
    end

    it "should has error which tags too much when submit tags number > 5" do
      sign_in user
      user.update_attribute :activated, true
      expect {
        post :create, article: {title: "Test", category_id: category.id, save: 1, tagstr: "ab,test,ba,bte,teb,bater"}, format: :js
        expect(flash[:warning]).to include I18n.t("errors.tags_too_much", size: 5)
      }.not_to change { user.articles.reload.size }
    end

    it "should save article when submit tags number <= 5" do
      sign_in user
      user.update_attribute :activated, true
      expect {
        post :create, article: { title: "test", category_id: category.id, save: 1, tagstr: "ab,cd,ef" }, format: :js
      }.to change { user.articles.reload.size }.by 1
    end

    it "should article posted eq true when post article" do
      sign_in user
      user.update_attribute :activated, true
      article.save
      expect(user.articles.reload.first).to eq article
      post :create, article: {title: "Test", category_id: category.id, post: 1}
      expect(user.articles.reload.first).not_to eq article
      expect(user.articles.reload.first.posted).to eq true
    end

    it "should redirect to root path when no post or save" do
      sign_in user
      user.update_attribute :activated, true
      post :create, article: {title: "Test", category_id: category.id }
      expect(response).to redirect_to root_path
    end
  end

  context "#update" do
    it "should redirect to sign in path when user no sign in" do
      patch :update, id: article.id
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
      expect(flash[:warning]).to include I18n.t("flash.warning.need_sign_in")
    end

    it "should redirect to root path when user no active" do
      sign_in user
      patch :update, id: article.id
      expect(response).to redirect_to root_path
      expect(flash[:warning]).to include I18n.t('flash.warning.need_activation')
    end

    it "should render 404 when non find article" do
      sign_in user
      user.update_attribute :activated, true
      patch :update, id: 1000
      expect(response).to have_http_status 404
    end

    it "should render 404 when current_user isn't owner of article" do
      sign_in other
      other.update_attribute :activated, true
      patch :update, id: article.id
      expect(response).to have_http_status 404
    end

    it "shouldn't has error when submit tags include ruby" do
      sign_in user
      user.update_attribute :activated, true
      expect(article.tags2str).not_to include 'ruby'
      patch :update, params: { id: article.id, article: { tagstr: 'ruby' } }
      expect(article.reload.tags2str).to include 'ruby'
    end

    it "shouldn't update when submit non-existed category" do
      sign_in user
      user.update_attribute :activated, true
      expect(article.valid?).to eq true
      patch :update, params: { id: article.id, article: { category_id: nil } }, format: :js
      expect(article.reload.category_id).not_to eq nil
    end

    it "should update successfully with submit existed category" do
      sign_in user
      user.update_attribute :activated, true
      article.save
      expect(user.reload.categories.include? category).to eq true
      new_category = Category.create name: "NewTest"
      expect(user.categories.include? new_category).to eq false

      patch :update, params: { id: article.id, article: { category_id: new_category.id, save: 1 } }, format: :js

      expect(article.reload.category_id).to eq new_category.id
      expect(user.categories.reload.include? new_category).to eq true           
    end

    it "should update tags with delete previous tags" do
      sign_in user
      user.update_attribute :activated, true
      patch :update, params: { id: article.id, article: { save: 1 , tagstr: "ab,cd,ef"} }, format: :js
      expect(article.reload.tags2str).to eq "ab,cd,ef"
      patch :update, params: { id: article.id, article: { save: 1 , tagstr: "abc,def"} }, format: :js
      expect(article.reload.tags2str).to eq "abc,def"
    end
  end

  context "#destroy" do
    it "should redirect to sign in path when user no sign in" do
      delete :destroy, id: article.id
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
      expect(flash[:warning]).to include I18n.t("flash.warning.need_sign_in")
    end

    it "should redirect to root path when user no active" do
      sign_in user
      delete :destroy, id: article.id
      expect(response).to redirect_to root_path
      expect(flash[:warning]).to include I18n.t('flash.warning.need_activation')
    end

    it "should render 404 when non find article" do
      sign_in user
      user.update_attribute :activated, true
      delete :destroy, id: 1000
      expect(response).to have_http_status 404
    end

    it "should render 404 when current_user isn't owner of article" do
      sign_in other
      other.update_attribute :activated, true
      delete :destroy, id: article.id
      expect(response).to have_http_status 404
    end

    it "should delete successfully with correct user" do
      sign_in user
      user.update_attribute :activated, true
      article.save
      expect(user.articles.reload.include? article).to eq true
      expect {
        delete :destroy, id: article.id
      }.to change { user.articles.all.size }.by -1
      expect(user.articles.reload.include? article).to eq false
    end

  end
end