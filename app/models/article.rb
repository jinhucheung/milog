class Article < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :title, :user_id, :category_id, presence: true
  validates :title, length: { maximum: 50 }
  validate :tags_number

  default_scope ->{ order created_at: :desc }
  scope :posted, -> { where posted: true }
  scope :unposted, ->{ where posted: false }
  scope :order_by_time, -> { reorder(nil).order created_at: :desc }
  scope :order_by_view_count, -> { reorder(nil).order view_count: :desc }

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

  def posted_week
    date = Date.today.beginning_of_week
    return (date..date + 6.days).to_a
  end

  def posted_year
    created_at.year
  end

  def comment_count
    comments.where(deleted_at: nil).size
  end

  class << self
    # 根据关键字搜索已发布的文章
    # 最多返回100条记录
    # usejinhur限制搜索范围
    def search_by_token(token, user: nil)
      return nil if token.blank?
      opts = {
        size: 100,
        query: {
          bool: {
            must: [
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
      }
      opts[:query][:bool][:must].push({ match: { user_id: user.id } }) unless user.blank?
      search(opts).records
    end

    # 根据文章阅读与评论数选择
    # 默认以评论数减序排列
    def select_by_view_and_comment(view_count: 0, comment_count: 0)
      Article.unscoped
             .joins('LEFT OUTER JOIN comments ON comments.article_id = articles.id')
             .where("articles.posted = ? AND
                     articles.view_count >= ? AND
                     comments.deleted_at IS NULL", true, view_count)
             .group("articles.id")
             .having("COUNT(*) >= ?", comment_count)
             .order("COUNT(*) DESC")
    end

    # 热门文章, 根据阅读数>=50 & 评论数>=10
    def hottest
      self.select_by_view_and_comment view_count: 50, comment_count: 10
    end

    # 最新文章
    def latest
      self.select_by_view_and_comment
    end

    # 返回某段时间内的文章
    # time values in [:day :week :month]
    def all_during_time(articles, time: :day)
      return [] if articles.blank? || time.blank?
      return [] unless %w[day week month].include? time.to_s
      _result = articles.map{ |article| article if article.created_at >= Time.now.public_send("beginning_of_#{time}") && article.created_at <= Time.now.public_send("end_of_#{time}") }
      self.where id: _result
    end

  end

  def create_notifications
    return unless self.posted
    self.user.followers.each do |follower|
      Notification.create(
        notify_type: 'article',
        actor: self.user,
        user: follower,
        target: self)
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