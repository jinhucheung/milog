module Admin::HomeHelper
  def user_state(user)
    return nil if user.blank?
    case user.state
      when 0
        I18n.t "c-summary.user.disabled"
      when 1
        I18n.t "c-summary.user.normal"
      when 2
        I18n.t "c-summary.user.admin"
    end
  end
end
