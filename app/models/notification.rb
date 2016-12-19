# Auto generate with notifications gem.
class Notification < ActiveRecord::Base
  include Notifications::Model

  belongs_to :user

  validates :user_id, :notify_type, presence: true
  validate :actor_and_user_are_not_equal

  self.per_page = 20

  private 
    # 确保消息发起者与通知者不同
    def actor_and_user_are_not_equal
      if user_id == actor_id
        self.errors.add :actor_id, I18n.t("actor_and_user_are_not_equal")
      end
    end
end
