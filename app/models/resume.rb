class Resume < ApplicationRecord
  validates :user_id, presence: true, uniqueness: true

  belongs_to :user
end
