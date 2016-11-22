class ResumePictureship < ApplicationRecord
  validates :resume_id, :picture_id, presence: true
  
  belongs_to :resume
  belongs_to :picture,     dependent: :destroy
end
