module V1
  class Users < Grape::API
    resource :users do
      # Get a active users list
      # 
      # Example Request:
      #   GET /users
      get do
        @users = User.abled
        present @users, with: Entities::User
      end

      # Get a user
      # 
      # Example Request:
      #   GET /users/:username
      get ':username' do
        @user = User.abled.find_by_username(params[:username])
        present @user, with: Entities::User
      end
    end

    resource :user do
      # Authorized user
      # 
      # Parameters:
      #   username(required)
      #   password(required)
      before do
        unauthorized! unless current_user
      end

      # Get authorized user
      # 
      # Example Request:
      #   Get /user
      get do
        present current_user, with: Entities::User
      end

      # Update authorized user
      # 
      # Example Request:
      #   Patch /user
      # Parameters:
      #   nickname(optional)
      #   bio(optional)
      #   github(optional)
      #   weibo(optional)
      #   website(optional)
      patch do
        attrs = attributes_for_keys [:nickname, :bio, :github, :weibo, :website]
        user = current_user
        not_found!("User not found") unless user
        if user.update_attributes_by_each(attrs)
          present user, with: Entities::User
        else
          not_found!
        end
      end
    end
  end
end