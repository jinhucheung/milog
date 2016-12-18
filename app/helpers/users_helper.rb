module UsersHelper
  include Users::AvatarHelper

  def build_user(username, email, password)
    user = User.new username: username, email: email,
                    password: password, password_confirmation: password
  end

  def capitalize_name(user)
    return "" if user.blank?
    user.username.capitalize
  end

  ## github链接
  def github_tag(user)
    return if user.blank? || user.github.blank?
    link = "https://github.com/" + user.github
    link_to content_tag(:i, '', class: 'fa fa-github icon'), link
  end

  ## weibo链接
  def weibo_tag(user)
    return if user.blank? || user.weibo.blank?
    link = "https://weibo.com/" + user.weibo
    link_to content_tag(:i, '', class: 'fa fa-weibo icon'), link
  end

  ## email链接
  def email_tag(user)
    return if user.blank? || user.email_public.blank? || user.email.blank?
    link = "mailto: " + user.email
    link_to content_tag(:i, '', class: 'fa fa-envelope icon'), link     
  end

  ## 个人网站
  def personal_website_tag(user)
    return if user.blank? || user.website.blank?
    link = user.website !~ /^http/ ? "http://" : ""
    link += user.website
    link_to content_tag(:i, '', class: 'fa fa-globe icon'), link 
  end

  ## 用户状态
  def user_state_tag(user)
    return if user.blank?
    return content_tag :span, t("user.normal"), class: 'label label-info' if user.state == 0
    content_tag :span, t("user.admin"), class: 'label label-danger' if user.state == 2
  end

  ## 关注状态
  def follow_tag(user)
    return if user.blank?
    has_followed = signed_in? && current_user.followed?(user)
    
    path = faclass = text = ""
    if has_followed
      path = unfollow_user_path user.username
      faclass = "fa fa-star-o"
      text = I18n.t "user.unfollow"
    else
      path = follow_user_path user.username
      faclass = "fa fa-star"
      text = I18n.t "user.follow"
    end

    content = content_tag(:i, "", class: faclass, id: 'follow-btn-fa') + "&nbsp;&nbsp;".html_safe +
              content_tag(:span, text, id: 'follow-btn-text')
    content = link_to content, path, method: :post, remote: true, class: 'btn btn-primary btn-block btn-follow', id: 'follow-btn-link'
    raw content
  end
  
end
