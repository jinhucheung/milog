class UserCategoryship < ApplicationRecord
  validates :user_id, :category_id, presence: true
  # 指定多字段唯一
  validates_uniqueness_of :user_id, scope: :category_id

  belongs_to :user
  belongs_to :category
end
