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

  def user_state_selected_tags(selected_value)
    value = 
      if selected_value.blank?
        1
      else
        selected_value
      end
    options = ""
    states = [I18n.t("c-summary.user.disabled"), I18n.t("c-summary.user.normal"), I18n.t("c-summary.user.admin")]
    states.each_with_index do |name, index|
      options += 
        if index != value
          content_tag :option, name, value: index 
        else
          content_tag :option, name, value: index, selected: 'selected'
        end
    end
    raw options
  end

  def boolean_selected_tags(selected_value)
    value = selected_value
    value = false if selected_value.blank?
    options = ""
    state = [true, false]
    state.each do |item|
      options +=
        if item != value
          content_tag :option, item, value: item 
        else
          content_tag :option, item, value: item, selected: 'selected'
        end
    end
    raw options
  end

end
