#= require jquery
#= require jquery_ujs
#= require jquery-fileupload/basic
#= require turbolinks
#= require bootstrap.min
#= require velocity
#= require rails-timeago
#= require jquery.timeago.settings
#
#= require markdown-it.min
#= require markdown-it-emoji.min
#= require highlight.pack
#= require tabIndent
#
#= require_self

window.App =
  locale: 'zh-CN'

# 当载入编写文章/简历时, 会定时发送请求, 更新文本
# 当页面更换时, 停止发送请求
window.interval = null
document.addEventListener "turbolinks:load", ()-> 
  return if window.interval == null
  clearInterval window.interval
  window.interval = null
