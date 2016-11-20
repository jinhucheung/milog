module CommentsHelper
  include MarkdownHelper

  # 显示评论内容
  def markdown_comment_tag(comment)
    return if comment.blank?
    comment_in_reply comment
    return sanitize_markdown comment.content_html if comment.content_html
    markdown_content = markdown_parser.render comment.content
    sanitize_markdown markdown_content    
  end

  # 为评论添加回复父级
  def comment_in_reply(comment)
    if parent = comment.parent 
      puser = parent.user

      reply_content = '@'+puser.username+ " · " +parent.indexno(suf: '')
      comment.content = reply_content + comment.content

      reply_content_html = link_to('@'+puser.username, user_path(puser.username)) + " · " +
                      link_to(parent.indexno(suf: ''), parent.indexno)
      reply_content_html = content_tag :span, reply_content_html, class: 'reply-tag'
      comment.content_html = reply_content_html + comment.content_html.html_safe
    end
  end
end