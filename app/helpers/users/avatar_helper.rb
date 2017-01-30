module Users::AvatarHelper
  include LetterAvatar::AvatarHelper

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

    return image_tag(letter_avatar_url('#', 120), class: img_class) if user.blank?

    avatar_url = user.user_avatar? ? user.avatar : user.letter_avatar_url(120)
    img = image_tag(avatar_url, class: img_class)
    
    if opts[:link]
      link_to raw(img), main_app.user_path(user.username), title: user.username
    else
      raw img
    end
  end
end