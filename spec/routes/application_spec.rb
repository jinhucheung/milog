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

  describe "accounts active" do 

    context "/accounts/:id/active is routable when id is valid " do 
      it "get /accounts/hijinhu/active" do 
        expect(get: 'accounts/hijinhu/active').to route_to 'accounts_settings#active', id: 'hijinhu'
      end

      it "get accounts/tetabtab/active" do 
        expect(get: 'accounts/tetabtab/active').to route_to 'accounts_settings#active', id: 'tetabtab'
      end

      it "get accounts/55brab-br/active" do 
        expect(get: 'accounts/55brab-br/active').to route_to 'accounts_settings#active', id: '55brab-br'
      end

      it "get accounts/bab42526b/active" do 
        expect(get: 'accounts/bab42526b/active').to route_to 'accounts_settings#active', id: 'bab42526b'
      end
    end

    context "/accounts/:id/active not routable when id is too short (minimum 6 chars)" do 
      it "get accounts/active" do 
        expect(get: 'accounts/active').not_to be_routable
      end

      it "get accounts/a/active" do 
        expect(get: 'accounts/a/active').not_to be_routable
      end

      it "get accounts/bab_/active" do 
        expect(get: 'accounts/bab_/active').not_to be_routable
      end

      it "get accounts/bab-0/active" do 
        expect(get: 'accounts/bab-0/active').not_to be_routable
      end
    end

    context "/accounts/:id/active not routable when id is invalid " do 
      it "get accounts/ba^brab/active" do 
        expect(get: 'accounts/ba^brab/active').not_to be_routable
      end

      it "get accounts/ba@brab/active" do 
        expect(get: 'accounts/ba@brab/active').not_to be_routable
      end

      it "get accounts/-tst1%1/active" do 
        expect(get: 'accounts/-tst1%1/active').not_to be_routable
      end
    end


    context "/accounts/:id/sendactivemail is routable when id is valid " do 
      it "get /accounts/hijinhu/sendactivemail" do 
        expect(get: 'accounts/hijinhu/sendactivemail').to route_to 'accounts_settings#send_active_mail', id: 'hijinhu'
      end

      it "get accounts/tetabtab/sendactivemail" do 
        expect(get: 'accounts/tetabtab/sendactivemail').to route_to 'accounts_settings#send_active_mail', id: 'tetabtab'
      end

      it "get accounts/55brab-br/sendactivemail" do 
        expect(get: 'accounts/55brab-br/sendactivemail').to route_to 'accounts_settings#send_active_mail', id: '55brab-br'
      end

      it "get accounts/bab42526b/sendactivemail" do 
        expect(get: 'accounts/bab42526b/sendactivemail').to route_to 'accounts_settings#send_active_mail', id: 'bab42526b'
      end
    end

    context "/accounts/:id/sendactivemail not routable when id is invalid " do 
      it "get accounts/ba^brab/sendactivemail" do 
        expect(get: 'accounts/ba^brab/sendactivemail').not_to be_routable
      end

      it "get accounts/ba@brab/sendactivemail" do 
        expect(get: 'accounts/ba@brab/sendactivemail').not_to be_routable
      end

      it "get accounts/-tst1%1/sendactivemail" do 
        expect(get: 'accounts/-tst1%1/sendactivemail').not_to be_routable
      end

      it "get accounts/sendactivemail" do 
        expect(get: 'accounts/sendactivemail').not_to be_routable
      end

      it "get accounts/a/sendactivemail" do 
        expect(get: 'accounts/a/sendactivemail').not_to be_routable
      end
    end

  end
end
