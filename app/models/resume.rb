class Resume < ApplicationRecord
  validates :user_id, presence: true, uniqueness: true

  belongs_to :user
  has_many :resume_pictureships,    dependent: :destroy
  has_many :pictures,               through: :resume_pictureships
end
