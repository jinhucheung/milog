class ArticleTagship < ApplicationRecord
  validates :article_id, :tag_id, presence: true

  belongs_to :article
  belongs_to :tag
  
end
