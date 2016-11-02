class User
  module Securable
    # 生成随机字段
    def new_token
      SecureRandom.urlsafe_base64
    end

    # 生成加密字段
    def digest_token(token)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create(token, cost: cost)
    end

    # 验证字段token是否匹配加密字段digest
    def authenticated?(attribute, token)
      digest = send "#{attribute}_digest"
      return false if digest.blank?
      BCrypt::Password.new(digest).is_password?(token)
    end

    # 设置加密字段digest
    def update_digest(attribute, value)
      update_attribute "#{attribute}_digest", value
    end
  end
end
