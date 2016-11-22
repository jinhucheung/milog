module ApplicationHelper

  ALLOW_TAGS = %w(p br img h1 h2 h3 h4 h5 h6 blockquote pre code b i iframe
                  strong em table tr td tbody th strike del u a ul ol li span hr)
  ALLOW_ATTRIBUTES = %w(href src class width height id title alt target rel data-floor frameborder allowfullscreen)

  def sanitize_markdown(content) 
    sanitize content, tags: ALLOW_TAGS, attributes: ALLOW_ATTRIBUTES
  end

  # 显示markdown内容
  # 文章/评论/简历
  # markdownable需要content_html/content字段
  def markdown_tag(markdownable)
    return if markdownable.blank?
    return sanitize_markdown markdownable.content_html unless markdownable.content_html.blank?
    markdown_content = markdown_parser.render markdownable.content
    sanitize_markdown markdown_content
  end
end
