class Comment < ApplicationRecord
  validates :content, :article_id, :user_id, :index, presence: true
  validate  :belong_to_posted_article

  default_scope ->{ order index: :asc }
  scope :order_by_time, -> { reorder(nil).order created_at: :desc }

  belongs_to :user
  belongs_to :article
  belongs_to :parent, class_name: 'Comment', foreign_key: 'reply_id'

  has_many :replys, class_name: 'Comment', foreign_key: 'reply_id'
  has_many :comment_pictureships,     dependent: :destroy
  has_many :pictures,                 through: :comment_pictureships

  before_validation :set_article_in_reply, on: :create
  before_create :cal_index
  after_commit :create_notifications, on: :create

  scope :posted, ->{ where deleted_at: nil }
  scope :deleting, ->{ where.not deleted_at: nil }

  def deleted?
    return !self.deleted_at.blank?
  end

  def indexno(pre: '#', suf: 'c')
    pre + self.index.to_s + suf
  end

  private 
    # 只能在已发布文章中评论
    def belong_to_posted_article
      return unless self.article
      unless self.article.posted
        errors.add :article, I18n.t("errors.must_be_posted")
      end
    end

    # 计算评论所在层数
    # 若comments不按index正向排序
    # 则使用comments.max_by(&:index).index
    def cal_index
      return unless self.article 
      comments = self.article.comments.reload
      if comments.any?
        self.index = comments.last.index + 1
      end
    end

    # 绑定回复与上级评论的文章
    def set_article_in_reply
      @parent = parent
      self.article = @parent.article if @parent
    end

    def create_notifications
      return unless self.user
      notifications = []
      parent = self.parent

      # 回复上级评论, 通知上级评论者
      notifications << { notify_type: 'mention', user: parent.user } if parent
      # 直接评论文章, 或者回复上级评论者不是文章所有者, 则通知文章所有者
      notifications << { notify_type: 'comment', user: article.user }  if article && (parent.blank? || parent.user != article.user)

      notifications.each do |notify|
        Notification.create(
          notify_type: notify[:notify_type],
          actor: self.user,
          user: notify[:user],
          target: self)
      end
    end
end
