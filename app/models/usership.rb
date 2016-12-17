class Usership < ApplicationRecord
  validates :follower_id, :following_id, presence: true
  validates_uniqueness_of :follower_id, scope: :following_id, message: I18n.t("errors.follower_following_be_unique")
  validate :follower_and_following_not_eq

  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  private
    def follower_and_following_not_eq
      errors.add :follower_id, I18n.t("errors.follower_not_eq_following") if follower_id == following_id
    end
end