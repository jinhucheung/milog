class Article < ApplicationRecord
  validates :title, :user_id, :category_id, presence: true
  validate :tags_number

  default_scope ->{ order created_at: :desc }

  belongs_to :user
  belongs_to :category
  has_many :article_tagships,     dependent: :destroy
  has_many :tags,                 through: :article_tagships

  attr_accessor :tagstr

  # 以字符串形式取出文章标签
  def tags2str
    self.tags.map { |tag| tag.name }.join ","
  end

  # 存储字符串形式的标签
  def str2tags(str)
    return if str.blank?
    str.split(/[,，]/).each do |tagname|
      tagname.strip!
      tag = Tag.find_or_create_by name: tagname
      self.article_tagships.find_or_create_by tag: tag
    end
  end

  # 标签最多为5个
  def tags_number
    return if tagstr.blank?
    maximum = 5
    if tagstr.split(/[,，]/).size > maximum
      errors.add :tag, I18n.t("errors.tags_too_much", size: maximum)
    end
  end
end