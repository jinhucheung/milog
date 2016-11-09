class Category < ApplicationRecord

  validates :name,    uniqueness: { case_sensitive: false },   
                      length: { maximum: 8 },
                      presence: true

  has_many :articles
  has_many :user_categoryships,  dependent: :destroy
  has_many :users,               through: :user_categoryships

  before_save :downcase_name

  private
    def downcase_name 
      name.downcase!
    end
end
