module ApplicationHelper

  ALLOW_TAGS = %w(p br img h1 h2 h3 h4 h5 h6 blockquote pre code b i iframe
                  strong em table tr td tbody th strike del u a ul ol li span hr)
  ALLOW_ATTRIBUTES = %w(href src class width height id title alt target rel data-floor frameborder allowfullscreen)

  def sanitize_markdown(content) 
    sanitize content, tags: ALLOW_TAGS, attributes: ALLOW_ATTRIBUTES
  end
end
