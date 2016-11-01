require "rails_helper"

RSpec.describe "ApplicationRoutes", type: :routing do 
	context "root" do 
		it "get / success" do 
			expect(get: '/').to route_to 'home#index'
		end
	end

	context "signup" do 
		it "get /signup success" do 
			expect(get: '/signup').to route_to 'accounts#new'
		end

		it "post /signup success" do 
			expect(post: '/signup').to route_to 'accounts#create'
		end

		it "get /users/new fail" do 
			expect(get: '/users/new').not_to be_routable
		end

		it "post /users fail" do 
			expect(post: '/users').not_to be_routable
		end
	end
end