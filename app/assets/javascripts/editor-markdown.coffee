#= require markdown-it.min
#= require markdown-it-emoji.min
#= require highlight.pack
#= require tabIndent
#= require editor-default
#= require markdown-toolbar
#= require emoji-picker

# 加载markdown-it语法高亮插件
hljs.initHighlightingOnLoad()
# 加载tab缩进插件
tabIndent.renderAll()

# 配置markdown-it 
this.md =  window.markdownit({
  linkify: true,               # 标识超链接
  highlight: (str, lang)->     # 语法高亮
    if lang && hljs.getLanguage lang 
      try
        return hljs.highlight(lang, str).value
    return ''
}).use(window.markdownitEmoji)

# 添加table规则
md.renderer.rules.table_open = (tokens, idx)->
  return '<table class="table table-striped table-bordered">'
# 支持emoji图标
md.renderer.rules.emoji = (token, idx)->
  return '<i class="em em-' + token[idx].markup + '"></i>';

# 编辑/预览区绑定markdownit
$("#edit-tabs").on "click", ".preview-node", ()-> 
  set_previewing true
  result = md.render $("#editor").val()
  $("#previewer").html result
  return

$("#edit-tabs").on "click", ".edit-node", ()-> 
  set_previewing false
  return

# markdown解析后结果, 提交给服务器
this.set_content_html = ()->
  result = md.render $("#editor").val()
  $("#content_html").val result
