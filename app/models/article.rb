class Article < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  validates :title, :user_id, :category_id, presence: true
  validate :tags_number

  default_scope ->{ order created_at: :desc }
  scope :posted, -> { where(posted: true) }

  belongs_to :user
  belongs_to :category
  has_many :article_tagships,      dependent: :destroy
  has_many :tags,                  through: :article_tagships
  has_many :article_pictureships,  dependent: :destroy
  has_many :pictures,              through: :article_pictureships
  has_many :comments,              dependent: :destroy

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

  def comment_count
    comments.size
  end

  class << self
    # 根据关键字搜索某用户已发布的文章
    # 最多返回100条记录
    def search_by_token_in_user(token, user)
      return nil if token.blank? || user.blank?
      search(
        size: 100,
        query: {
          bool: {
            must: [
              { match: { user_id: user.id } },
              { match: { posted: true } },
              { multi_match: 
                {
                  query: token.to_s,
                  fields: ['title', 'content']
                } 
              }
            ]
          }
        },
        highlight: {
          pre_tags: ["<strong>"],
          post_tags: ["</strong>"],
          number_of_fragments: 1,
          fragment_size: 100,
          fields: {
              title: { number_of_fragments: 0 },
              content: {}
          }
        }
      ).records
    end    
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