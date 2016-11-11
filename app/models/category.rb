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

  private
    def downcase_name 
      name.downcase!
    end
end
