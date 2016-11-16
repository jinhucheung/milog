class ArticlePictureship < ApplicationRecord
  validates :article_id, :picture_id, presence: true

  belongs_to :article
  belongs_to :picture,   dependent: :destroy

end
