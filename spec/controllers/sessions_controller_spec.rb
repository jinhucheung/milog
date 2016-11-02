require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe '#new' do
    it "should have new action" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "should render new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    it "should raise error when receive nil params" do
      expect {
        post :create
      }.to raise_error
    end
  end

end
