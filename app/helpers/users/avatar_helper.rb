module Users::AvatarHelper
  # 返回头像样式
  # xs: 22px
  # sm: 32px
  # md: 48px
  # lg: 100px
  def avatar_class(size)
    case size
      when :xs then 'avatar-xs'
      when :sm then 'avatar-sm'
      when :md then 'avatar-md'
      when :lg then 'avatar-lg'
      else 'avatar-md'
    end
  end

  def avatar_tag(user, size = :md, opts = {})
    img_class = avatar_class size

    if user.blank?
      return content_tag :div, '#', class: img_class
    end

    letter = user.username[0].upcase
    img =
      if user.user_avatar?
        image_tag user.avatar, class: img_class
      else
        content_tag :div, letter, class: img_class, style: "background: #{user.avatar_color}"
      end
    if opts[:link]
      link_to raw(img), user_path(user.username)
    else
      raw img
    end
  end
end