class Comment < ApplicationRecord
  validates :content, :article_id, :user_id, :index, presence: true
  validate  :belong_to_posted_article

  default_scope ->{ order index: :asc }

  belongs_to :user
  belongs_to :article

  has_many :replys, class_name: 'Comment', foreign_key: 'reply_id'

  before_validation :set_article_in_reply, on: :create
  before_save :cal_index

  # 获取回复的上级节点
  def parent
    return nil if self.reply_id.blank?
    Comment.find_by id: self.reply_id
  end

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
      _parent = parent
      self.article = _parent.article if _parent
    end
end
