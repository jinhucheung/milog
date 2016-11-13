class Tag < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }, 
                   presence: true

  has_many :article_tagships,   dependent: :destroy
  has_many :articles,           through: :article_tagships

  before_save :downcase_and_strip_name

  private
    def downcase_and_strip_name
      name.downcase!
      name.strip!
    end

end
