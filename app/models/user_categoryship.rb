class UserCategoryship < ApplicationRecord
  validates :user_id, :category_id, presence: true

  belongs_to :user
  belongs_to :category
end
