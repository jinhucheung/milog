class Tag < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }, 
                   presence: true

  has_many :article_tagships,   dependent: :destroy
  has_many :articles,           through: :article_tagships

  before_save :downcase_and_strip_name

  def posted_articles(user)
    return nil if user.blank?
    articles.where(user: user, posted: true)
  end

  class << self
    # 已有文章使用中的标签
    def used
      _result = self.find_by_sql "
        SELECT DISTINCT tags.id, tags.name
        FROM  tags
        LEFT OUTER JOIN article_tagships
        ON tags.id = article_tagships.tag_id
        WHERE article_tagships.tag_id IS NOT NULL
      "
      self.where id: _result
    end

    # 未有文章使用的标签
    def unused
      _result = self.find_by_sql "
        SELECT DISTINCT tags.id, tags.name
        FROM  tags
        LEFT OUTER JOIN article_tagships
        ON tags.id = article_tagships.tag_id
        WHERE article_tagships.tag_id IS NULL
      "
      self.where id: _result
    end

  end

  private
    def downcase_and_strip_name
      name.downcase!
      name.strip!
    end

end
