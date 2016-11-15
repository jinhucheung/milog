module ArticlesHelper
  include Article::MarkdownHelper

  ## 已选中的分类项
  def category_selected_tag(category, opts = {})
    return if category.blank?
    return content_tag :span, I18n.t("categories.default"), opts if category.name == 'default'
    content_tag :span, category.name, opts
  end

  # 用户所有分类项
  def category_menu_li_tag(category, selected)
    return if category.blank?
    style = "category-item"
    style += " li-active" if selected
    category_content =  
      if category.name == 'default'
        content_tag :span, I18n.t("categories.default"), class: 'content', value: category.id
      else
        content_tag(:span, category.name, class: 'content', value: category.id) +
        content_tag(:span, '', class: 'setting fa fa-cog fa-fw', role: 'button')
      end
    content_tag :li, link_to(category_content, '#'), class: style
  end

  # 文章分类标签
  def category_tag(category)
    return if category.blank?
    if category.name == 'default'
      link_to I18n.t("categories.default"), '#'
    else
      link_to category.name, '#'
    end
  end

  ## 时间标签
  def time_tag(time, strf: "%Y-%m-%d %H:%M", opts: {})
    return if time.blank?
    content_tag :span, time.strftime(strf), opts
  end

  # 关键字标签
  def tags_tag(tags)
    return if tags.blank?
    content = tags.map { |tag| link_to '# '+tag.name, '#' }.join ' · '
    sanitize content
  end

  # 前一篇文章
  def pre_article_tag(pre_article)
    return if pre_article.blank?
    content = content_tag(:i, '', class: 'fa fa-chevron-left') + ' ' + pre_article.title
    link_to sanitize(content), article_path(pre_article)
  end

  # 后一篇文章
  def next_article_tag(next_article)
    return if next_article.blank?
    content = next_article.title + ' '+ content_tag(:i, '', class: 'fa fa-chevron-right')
    link_to sanitize(content), article_path(next_article)
  end

  # 显示文章内容
  def markdown_article_tag(article)
    return if article.blank?
    return sanitize_markdown article.content_html if article.content_html
    markdown_content = markdown_parser.render article.content
    sanitize_markdown markdown_content
  end

  # 显示文章部分内容
  def truncate_article_tag(article, opts={})
    return if article.blank? || article.content.blank?
    content = article.content.strip[0..200]
    # 格式化换行
    content = content.gsub(/#/, '').gsub /(\r\n)+/i, '<br>'
    # 省略号置换最后的换行符
    content = content.gsub /<br>$/i, ''
    content += "..."
    # 其他特殊字符由markdown渲染
    content = markdown_parser.render content
    content_tag :div, sanitize_markdown(content), opts
  end
end
