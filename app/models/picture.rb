class Picture < ApplicationRecord
  # user_id 与 posted 字段 
  # 区分用户缓存 或 已在文章或评论中使用的图片

  validates :picture, :user_id, presence: true
  validate :picture_size

  has_one :article_pictureship,   dependent: :destroy
  has_one :article,     through: :article_pictureship
  belongs_to :user

  mount_uploader :picture, PictureUploader

  scope :posted, ->{ where posted: true }
  scope :unposted, ->{ where posted: false }

  private 
    def picture_size
      if picture.size > 2.megabytes
        errors.add :picture,  I18n.t("errors.picture_too_big", size: 2)
      end
    end
end
