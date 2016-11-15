class Category < ApplicationRecord

  validates :name,    uniqueness: { case_sensitive: false },   
                      length: { maximum: 8 },
                      presence: true

  has_many :articles
  has_many :user_categoryships,  dependent: :destroy
  has_many :users,               through: :user_categoryships

  default_scope -> { order id: :asc }

  before_save :downcase_name

  # 默认分类
  DEFAULT = %w(default 默认)

  def posted_articles(user)
    return nil if user.blank?
    articles.where(user: user, posted: true)
  end

  def mname
    return I18n.t 'categories.default' if self.name == 'default'
    self.name
  end

  private
    def downcase_name 
      name.downcase!
    end
end
