class Hold < ApplicationRecord
  validates :user_id, :holdable_type, presence: true
  validate  :check_holdable_type

  belongs_to :user

  before_save :capitalize_type

  ALLOWED_HOLDABLE_TYPES = %w(Article Resume)

  private 
    def check_holdable_type
      return if holdable_type.blank?
      capitalize_type = holdable_type.capitalize
      unless ALLOWED_HOLDABLE_TYPES.include? capitalize_type
        errors.add :holdable_type, I18n.t("errors.not_right")
      end
    end

    def capitalize_type
      return if holdable_type.blank?
      holdable_type.capitalize!
    end
end