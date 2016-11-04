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

  end

  context "signin" do
    it "get /signin success" do
      expect(get: '/signin').to route_to 'sessions#new'
    end

    it "post /signin success" do 
      expect(post: '/signin').to route_to 'sessions#create'
    end
  end

  context 'signout' do
    it "delete /signout success" do 
      expect(delete: '/signout').to route_to 'sessions#destroy'
    end
  end

  context "users" do
    it "get /users/new fail" do
      expect(get: '/users/new').not_to be_routable
    end

    it "post /users fail" do
      expect(post: '/users').not_to be_routable
    end

    it "get /users fail" do
      expect(get: '/users').not_to be_routable
    end

    it "get /users/1 fail" do
      expect(get: '/users/1').not_to be_routable
    end

    it "get /1 fail" do
      expect(get: '/1').not_to be_routable
    end
  end

  describe "api" do 

    context "/accounts/:id/active is routable when id is valid " do 
      it "get /accounts/hijinhu/active" do 
        expect(get: 'api/accounts/hijinhu/active').to route_to 'api/accounts#active', id: 'hijinhu'
      end

      it "get api/accounts/tetabtab/active" do 
        expect(get: 'api/accounts/tetabtab/active').to route_to 'api/accounts#active', id: 'tetabtab'
      end

      it "get api/accounts/55brab-br/active" do 
        expect(get: 'api/accounts/55brab-br/active').to route_to 'api/accounts#active', id: '55brab-br'
      end

      it "get api/accounts/bab42526b/active" do 
        expect(get: 'api/accounts/bab42526b/active').to route_to 'api/accounts#active', id: 'bab42526b'
      end
    end

    context "/accounts/:id/active not routable when id is too short (minimum 6 chars)" do 
      it "get api/accounts/active" do 
        expect(get: 'api/accounts/active').not_to be_routable
      end

      it "get api/accounts/a/active" do 
        expect(get: 'api/accounts/a/active').not_to be_routable
      end

      it "get api/accounts/bab_/active" do 
        expect(get: 'api/accounts/bab_/active').not_to be_routable
      end

      it "get api/accounts/bab-0/active" do 
        expect(get: 'api/accounts/bab-0/active').not_to be_routable
      end
    end

    context "/accounts/:id/active not routable when id is invalid " do 
      it "get api/accounts/ba^brab/active" do 
        expect(get: 'api/accounts/ba^brab/active').not_to be_routable
      end

      it "get api/accounts/ba@brab/active" do 
        expect(get: 'api/accounts/ba@brab/active').not_to be_routable
      end

      it "get api/accounts/-tst1%1/active" do 
        expect(get: 'api/accounts/-tst1%1/active').not_to be_routable
      end
    end


    context "/accounts/:id/sendactivemail is routable when id is valid " do 
      it "get /accounts/hijinhu/sendactivemail" do 
        expect(get: 'api/accounts/hijinhu/sendactivemail').to route_to 'api/accounts#send_active_mail', id: 'hijinhu'
      end

      it "get api/accounts/tetabtab/sendactivemail" do 
        expect(get: 'api/accounts/tetabtab/sendactivemail').to route_to 'api/accounts#send_active_mail', id: 'tetabtab'
      end

      it "get api/accounts/55brab-br/sendactivemail" do 
        expect(get: 'api/accounts/55brab-br/sendactivemail').to route_to 'api/accounts#send_active_mail', id: '55brab-br'
      end

      it "get api/accounts/bab42526b/sendactivemail" do 
        expect(get: 'api/accounts/bab42526b/sendactivemail').to route_to 'api/accounts#send_active_mail', id: 'bab42526b'
      end
    end

    context "/accounts/:id/sendactivemail not routable when id is invalid " do 
      it "get api/accounts/ba^brab/sendactivemail" do 
        expect(get: 'api/accounts/ba^brab/sendactivemail').not_to be_routable
      end

      it "get api/accounts/ba@brab/sendactivemail" do 
        expect(get: 'api/accounts/ba@brab/sendactivemail').not_to be_routable
      end

      it "get api/accounts/-tst1%1/sendactivemail" do 
        expect(get: 'api/accounts/-tst1%1/sendactivemail').not_to be_routable
      end

      it "get api/accounts/sendactivemail" do 
        expect(get: 'api/accounts/sendactivemail').not_to be_routable
      end

      it "get api/accounts/a/sendactivemail" do 
        expect(get: 'api/accounts/a/sendactivemail').not_to be_routable
      end
    end

  end
end
