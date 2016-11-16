# 描述编辑/预览状态
this.$is_previewing = false
# 编辑区
$editor = document.getElementById 'editor'
# 工具项标识前缀(pre) 标识：.pre+name
$item_name_pre = "add-"

$items = new Array(
  { name: "bold",       offset_start: -4,  offset_end: -2,  markdown: "**" + '粗体' + "**" },
  { name: "italic",     offset_start: -4,  offset_end: -2,  markdown: " _" + '斜体' + "_ " }, 
  { name: "header",     offset_start: -2,  offset_end: 0,   markdown: "### " + '标题' }, 
  { name: "quote-left", offset_start: -8,  offset_end: 0,   markdown: "> 这里输入引用文本" }, 
  { name: "list-ul",    offset_start: -13, offset_end: -6,  markdown: "- 这里是列表文本\n- \n- " }, 
  { name: "list-ol",    offset_start: -15, offset_end: -8,  markdown: "1. 这里是列表文本\n2. \n3. " }, 
  { name: "code",       offset_start: -10, offset_end: -4,  markdown: "```\n这里输入代码\n```" },
  { name: "link",       offset_start: -16, offset_end: -10, markdown: "[输入链接说明](http://)" }, 
  { name: "image",      offset_start: -16, offset_end: -10, markdown: "![输入图片说明](http://)" }, 
  { name: "smile-o",    is_plugin: true, id: 0, type: "emoji" } 
)

## 工具项事件处理
# 编辑框光标后插字符
# $editor : 编辑框
# $insert_str: 插入的字符
#  $offset_start: 插入字符后光标的起始偏移量 (插入前光标+插入字符长度+偏移量) 
#  $offset_end: 插入字符后光标的终止偏移量
this.insert_at_cursor = ($editor, $insert_str, $offset_start, $offset_end)->
  if document.selection
    # IE 支持
    $editor.focus()
    selection = "";
    sel = document.selection.createRange()
    selection = sel.text
    sel.text = $insert_str
    sel.moveStart "character", $offset_start
    sel.moveEnd "character", $offset_end
    sel.select()
    if selection != "" 
      sel.text = selection
  else if $editor.selectionStart || $editor.selectionStart == 0         
    #Firefox/Chrome 等支持
    selection = ""
    startPos = $editor.selectionStart
    endPos = $editor.selectionEnd
    if startPos != endPos
      selection = $editor.value.substring startPos, endPos
    $editor.value = $editor.value.substring(0, startPos) + $insert_str + $editor.value.substring(endPos, $editor.value.length)
    $editor.selectionStart = startPos + $insert_str.length + $offset_start
    $editor.selectionEnd = startPos + $insert_str.length + $offset_end
    if selection != "" 
      $editor.value = $editor.value.substring(0, $editor.selectionStart) + selection + $editor.value.substring($editor.selectionEnd, $editor.value.length) 
  else 
    #直接在编辑文本末插入字符
    $editor.value += $insert_str 

# 设置是否在预览
this.set_previewing = (is_preview)->
  this.$is_previewing = is_preview

# 工具项点击处理公有部分
toolbar_item_on_click = ($insert_str, $offset_start, $offset_end)->
  if $is_previewing
    return
  # 当前不处于编辑区，则切换到编辑区
  if !$("#edit-tabs .edit-node").is ".edit-tab-border-deepen" 
    $("#edit-tabs .edit-node").click()
  # 插入值
  insert_at_cursor $editor, $insert_str, $offset_start, $offset_end
  return false

# 绑定工具项点击事件
bind_item_on_click = ($item)->
  classname = "." + $item_name_pre + $item.name
  $(".markdown-toolbar").on "click", classname, ()-> 
    toolbar_item_on_click $item.markdown, $item.offset_start, $item.offset_end

# 绑定表情选择工具项事件
bind_item_emoji_picker_on_click = ($item)->
  classname = "." + $item_name_pre + $item.name
  $(".markdown-toolbar").on "click", classname, ()->
    $(".emoji-menu-tab a").eq(0).click()

# 绑定触发上传图片事件
bind_image_item_on_click = ($item)->
  classname = "." + $item_name_pre + $item.name  
  $(".markdown-toolbar").on "click", classname, ()-> 
    $("#upload-picture-input").click()

# 插入图片链接
insert_picture_url = ($item, $picture_url)->
  if !$("#edit-tabs .edit-node").is ".edit-tab-border-deepen" 
    $("#edit-tabs .edit-node").click()

  if $picture_url != null && $picture_url != ""
    insert_at_cursor $editor, "![输入图片说明]("+$picture_url+")", 0, 0
  else
    insert_at_cursor $editor, $item.markdown, $item.offset_start, $item.offset_end

# 上传图片处理
this.upload_picture = {
  fail_on_picture_size: ()->
    return false
  fail_on_server: (msg)->
    return false
  load: ($item)->
    # 上传配置
    $("#upload-picture-input").fileupload {
      url: '/pictures',
      type: 'POST',
      autoUpload: false,
      add: (e, data)->
        # 限制文件大小, 不接受大于2MB的图片
        size_in_megabytes = data.files[0].size/1024/1024
        if size_in_megabytes > 2
          upload_picture.fail_on_picture_size()
        else
         data.submit()
      success: (data)->
        if data.status == 200
          insert_picture_url $item, data.url
        else
          insert_picture_url $item, null
          upload_picture.fail_on_server data.msg
    }
}

# 注册事件
bind_toolbar = ()->
  for item in $items
    if !item.is_plugin
      # 绑定点击处理, 插入图像单独处理
      if item.name != "image"
        bind_item_on_click item 
      else
        bind_image_item_on_click item
        upload_picture.load item
    else 
      # 非markdown插件工具项单独绑定事件,如表情包等
      bind_item_emoji_picker_on_click item

$(bind_toolbar())

