require "rails_helper"

RSpec.describe HomeController, type: :controller do

  describe "#index" do
    it "shouldn't redirect sign_in path to when user not sign in" do
      get :index
      expect(response).not_to redirect_to signin_path
      expect(response).not_to have_http_status(:redirect)
    end

    it "should render index" do
      get :index
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:success)
    end
  end
end
