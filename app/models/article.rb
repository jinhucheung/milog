class Article < ApplicationRecord
  validates :title, :user_id, :category_id, presence: true

  default_scope ->{ order created_at: :desc }

  belongs_to :user
  belongs_to :category

end