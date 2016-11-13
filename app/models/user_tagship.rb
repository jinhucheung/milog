class UserTagship < ApplicationRecord
  validates :user_id, :tag_id, presence: true

  belongs_to :user
  belongs_to :tag
end
