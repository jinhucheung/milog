class Article < ApplicationRecord
  validates :title, :user_id, :category_id, presence: true
  validate :tags_number

  default_scope ->{ order created_at: :desc }

  belongs_to :user
  belongs_to :category
  has_many :article_tagships,      dependent: :destroy
  has_many :tags,                  through: :article_tagships
  has_many :article_pictureships,  dependent: :destroy
  has_many :pictures,              through: :article_pictureships

  attr_accessor :tagstr

  after_save :build_user_and_category_ships

  # 以字符串形式取出文章标签
  def tags2str
    self.tags.map { |tag| tag.name }.join ","
  end

  # 存储字符串形式的标签
  def str2tags(str)
    return if str.blank?
    str.split(/[,，]/).each do |tagname|
      tagname.strip!
      tag = Tag.find_or_create_by name: tagname.html_safe
      self.article_tagships.find_or_create_by tag: tag
    end
  end

  def update_tags(str)
    return if str.blank?
    return if str.strip == tags2str
    self.article_tagships.destroy_all
    str2tags str
  end

  def posted_year
    created_at.year
  end

  private
    # 标签最多为5个
    def tags_number
      return if tagstr.blank?
      maximum = 5
      if tagstr.split(/[,，]/).size > maximum
        errors.add :tag, I18n.t("errors.tags_too_much", size: maximum)
      end
    end

    def build_user_and_category_ships
      unless user.categories.include? category
        user.user_categoryships.create category: category
      end
    end
end