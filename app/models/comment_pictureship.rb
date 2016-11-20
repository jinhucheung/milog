class CommentPictureship < ApplicationRecord
  validates :comment_id, :picture_id, presence: true

  belongs_to :comment
  belongs_to :picture,   dependent: :destroy
end
