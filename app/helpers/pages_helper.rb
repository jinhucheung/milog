module PagesHelper
  ## 切换语系
  def link_to_locale(path, mclass: '')
    link_text = I18n.t(:lang) == "EN" ? "中文" : "EN"
    link_url = I18n.t(:lang) == "EN" ? path + "?locale=zh-CN" : path + "?locale=en"
    link_to link_text, link_url, id: "locale_btn", class: mclass
  end

  ## 注册登录页面标签切换
  # path: 标识当前页面(signup/signin)
  # text: 标签文本, 当text=path时, 显示css_class
  # css_class: 显示的样式
  def link_to_login(text, css_class, path)
    link_class = css_class	if text == path
    link_text = I18n.send(:t, text)
    link_to link_text, "#", class: link_class
  end

  # 只显示对应的注册登录表单
  def show_or_hidden_login_div(text, path)
    display_value = text == path ? "block" : "none"
    "style= 'display: #{display_value}'".html_safe
  end

  ## 设置标题
  def title(pre_title = '')
    site_name = "Milog"
    return site_name if pre_title.blank?
    pre_title + " · " + site_name
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
    link = user.website
    link_to content_tag(:i, '', class: 'fa fa-globe icon'), link 
  end

  ## 已选中的分类项
  def category_selected_tag(category, opts = {})
    return if category.blank?
    return content_tag :span, I18n.t("categories.default"), opts if category.name == 'default'
    content_tag :span, category.name, opts
  end

  ## 用户所有分类项
  def category_menu_li_tag(category, selected)
    return if category.blank?
    style = "category-item"
    style += " li-active" if selected
    category_content =  
      if category.name == 'default'
        content_tag :span, I18n.t("categories.default"), class: 'content', value: category.id
      else
        content_tag(:span, category.name, class: 'content', value: category.id) +
        content_tag(:span, 'x', class: 'delete', role: 'button')
      end
    content_tag :li, link_to(category_content, category_path(category), method: 'delete'), class: style
  end

end
