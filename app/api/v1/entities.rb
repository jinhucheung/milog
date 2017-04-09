module V1
  module Entities
    class User < Grape::Entity
      expose :id, :username, :nickname, :bio, :github, :weibo, :website, :created_at, :updated_at
      expose :email, if: lambda{|user, options| user.email_public? || options[:current_user] }
      expose (:avatar) {|user| user.user_avatar? ? user.avatar_url : user.letter_avatar_url}
      expose (:activated) {|user| user.activated? }
      expose (:activated_at), if: lambda{|user, options| user.activated_at if user.activated?}
      expose :state do |user|
        case user.state
        when 0 then 'disable'
        when 1 then 'normal'
        when 2 then 'admin'
        end
      end
    end
  end
end