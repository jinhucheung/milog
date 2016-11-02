require "rails_helper"

RSpec.describe HomeController, type: :controller do

  describe "#index" do
    it "should redirect sign_in path to when user not sign in" do
      get :index
      expect(response).to redirect_to signin_path
      expect(response).to have_http_status(:redirect)
    end
  end
end
