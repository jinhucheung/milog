require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do 
  let(:default_category) { Category.create name: 'default' }
  let(:user) { User.create username: "aTestUser", email: "aTestUser@test.com", password: "aTestUserPsw", password_confirmation: "aTestUserPsw" }

  describe '#create' do
    let(:category) { Category.create name: 'ruby' }

    it "should redirect to sign in path when user doesn't sign in" do
      post :create
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
    end

    it "should redirect to root path and send valid mail when user doesn't active" do
      sign_in user
      post :create
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to root_path
      expect(flash[:warning]).not_to eq nil
    end 

    context "user has signed in and activated" do
      before :each do 
        sign_in user
        user.update_attribute :activated, true      
      end

      it "should render success when user add category but categories not include" do   
        expect(user.categories.where name: 'rails').to be_empty
        expect {
          post :create, category: { name: 'rails' }
        }.to change { Category.all.reload.size }.by 1
        user.user_categoryships.reload
        expect(user.categories.where name: 'rails').not_to be_empty
      end

      it "should render success when user add category and categories include it" do
        category.save
        expect(Category.where name: 'ruby').not_to be_empty  
        expect(user.categories.where name: 'ruby').to be_empty
        expect {
          post :create, category: { name: 'ruby' }
        }.to change { Category.all.reload.size }.by 0
        user.user_categoryships.reload
        expect(user.categories.where name: 'ruby').not_to be_empty        
      end

      it "should render error when user add category with 'default'/'默认'" do 
        expect(user.categories.where name: 'default').not_to be_empty
        expect {
          post :create, category: { name: 'Default' }
        }.to change { Category.all.reload.size }.by 0
        expect {
          post :create, category: { name: 'default' }
        }.to change { user.categories.reload.size }.by 0
        expect {
          post :create, category: { name: '默认' }
        }.to change { Category.all.reload.size }.by 0    
      end

      it "should render error when user has this add category" do
      
        user.categories.create name: 'study'
        expect {
          post :create, category: { name: 'Study' }
        }.not_to change { user.categories.reload.size }
      end

      it "should render error when user submit invalid category name" do     
        expect {
          post :create, category: { name: 't'*9 }
        }.not_to change { user.categories.reload.size }
      end
    end
  end

  describe '#destroy' do
    it "should redirect to sign in path when user doesn't sign in" do
      delete :destroy, id: 1 
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
    end

    it "should redirect to root path and send valid mail when user doesn't active" do
      sign_in user
      delete :destroy, id: 1 
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to root_path
      expect(flash[:warning]).not_to eq nil
    end 

    context "user has signed in and activated" do
      before :each do 
        sign_in user
        user.update_attribute :activated, true      
      end

      it "should render error when user delete default category" do
        expect {
          delete :destroy, id: 1 
        }.not_to change { user.user_categoryships.reload.size }
        expect(user.categories.where name: 'default').not_to be_empty
      end

      it "should render error when user delete no-existed category" do
        expect(user.categories.where id: 5).to be_empty
        expect{
          delete :destroy, id: 5
        }.not_to change { user.user_categoryships.reload.size }
      end

      it "should render success when user delete existed category" do
        category = user.categories.create name: 'testtest'
        expect {
          delete :destroy, id: category.id
        }.to change { user.user_categoryships.reload.size }.by -1
        expect(user.user_categoryships.include? category).to eq false
        expect(Category.all.include? category).to eq true
      end
    end
  end

  describe '#update' do
    it "should redirect to sign in path when user doesn't sign in" do
      patch :update, id: 1 
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to signin_path
    end

    it "should redirect to root path and send valid mail when user doesn't active" do
      sign_in user
      patch :update, id: 1 
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to root_path
      expect(flash[:warning]).not_to eq nil
    end

    context "user has signed in and activated" do
      before :each do 
        sign_in user
        user.update_attribute :activated, true      
      end

      it "should render error when user rename category with 'default'/'默认'" do     
        expect(user.categories.where name: 'default').not_to be_empty
        patch :update, params: { id: 1, category: { name: 'breab41' } }
        expect(user.categories.reload.where name: 'breab41').to be_empty
        patch :update, params: { id: 1, category: { name: 'brabbr' } }
        expect(user.categories.reload.where name: 'brabbr').to be_empty
        expect(user.categories.reload.where name: 'default').not_to be_empty
      end

      it "should render error when user rename to 'default/默认'" do
        category = user.categories.create name: 'hello'
        id = category.id
        patch :update, params: { id: id, category: { name: 'default' }}
        expect(category.reload.name).to eq 'hello'
        patch :update, params: { id: id, category: { name: '默认' }}
        expect(category.reload.name).to eq 'hello'
      end

      it "should render error when user rename no-existed category" do
        expect(user.categories.where id: 5).to be_empty
        patch :update, params: { id: 5, category: { name: 'stub' } }
        expect(user.categories.reload.where name: 'stub').to be_empty
      end      

      it "should render error when user rename category to existed-name" do
        c1 = user.categories.create name: 'hello'
        c2 = user.categories.create name: 'test2'
        id = c2.id
        patch :update, params: { id: c2.id, category: { name: 'hello' } }
        expect(c2.reload.name).to eq 'test2'
      end

      it "should render success when user rename that this name not-existed in categories" do
        expect(Category.where name: 'a'*5).to be_empty
        category = user.categories.create name: 'hello'
        patch :update, params: { id: category.id, category: { name: 'a'*5 } }
        expect(category.reload.name).to eq 'a'*5        
      end

      it "should render error when user rename that this name not-existed but invalid in categories" do
        expect(Category.where name: 'a'*9).to be_empty
        category = user.categories.create name: 'hello'
        patch :update, params: { id: category.id, category: { name: 'a'*9 } }
        expect(category.reload.name).not_to eq 'a'*9        
      end

      it "should render success when user rename that this name existed in categories" do
        category = Category.create name: 'a'*5
        rename_category = user.categories.create name: 'hello'
        expect(user.categories.where name: category.name).to be_empty
        patch :update, params: { id: rename_category.id, category: { name: 'a'*5 } }
        user.user_categoryships.reload
        expect(user.categories.where name: category.name).not_to be_empty
        expect(user.categories.include? rename_category).to eq false
        expect(user.categories.include? category).to eq true
      end

      it "should reset category of article when  user rename that this name existed in categories" do
        rename_category = user.categories.create name: 'hello'
        category = Category.create name: 'a'*5
        article1 = user.articles.create title: 'A', category: rename_category
        article2 = user.articles.create title: 'B', category: rename_category

        expect(user.articles.reload.size).to eq 2
        expect(article1.category).to eq rename_category
        expect(article2.category).to eq rename_category

        patch :update, params: { id: rename_category.id, category: { name: 'a'*5 } }
         
        expect(article1.reload.category).to eq category
        expect(article2.reload.category).to eq category
      end

    end
  end

end 