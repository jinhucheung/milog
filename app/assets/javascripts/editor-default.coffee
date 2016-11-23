# 文章编辑区样式处理： 正处于编辑区则加深边线
editor_sytle_handler = ()->
  $edit_tabs = $("#edit-tabs")
  $edit_tabs_lia = $("#edit-tabs li a")
  $edit_content = $("#tab-content")

  # 在编辑区或预览区 则边线加深
  # $tab_index区分编辑区或预览区
  edit_border_deepen = ($tab_index)->
    $edit_tabs.addClass "edit-tabs-border-deepen"
    $edit_content.addClass "edit-cotent-border-deepen"
    $edit_tabs_lia.eq($tab_index).addClass "edit-tab-border-deepen" 

  # 不在编辑区 边线变浅
  edit_border_clear = ()->
    $edit_tabs.removeClass "edit-tabs-border-deepen"
    $edit_content.removeClass "edit-cotent-border-deepen"
    $edit_tabs_lia.each ()->
      $(this).removeClass "edit-tab-border-deepen"

  # 获取编辑区的节点
  $(document).click (e)->
    $edit_node = $(e.target)  # 获取当前页面的点击节点
    # 节点是工具项,不清除边线
    if  $edit_node.is(".toolbar-item") || $edit_node.is(".toolbar-item i") 
      return false 
    # 清除之前的边线样式
    edit_border_clear()
    # 判断是否为编辑区的节点
    if  $edit_node.is(".edit-body-node")
      $edit_or_preview = 0
      if $edit_node.is(".edit-node") 
        $edit_or_preview = 0  # 是编辑节点
      else
        $edit_or_preview = 1  # 是预览节点
      edit_border_deepen($edit_or_preview)

# 标签输入处理
tag_input_handler = ()->
  # 根据逗号数限制用户输入
  $("#tag-input").on "keyup", ()->
    $str = $(this).val()
    $tags = $str.split /[,，]/
    if $tags.length >= 6 
      $tags = $tags.slice 0, 5 # 截取前5个元素
      $str=$tags.join ","
      if  $str.charAt($str.length-1) == ','
        $str.replace ",", ""
    else 
      $str=$tags.join ","
    $(this).val $str

# load
$(()->
  editor_sytle_handler()
  tag_input_handler()
  $("#title-input").on "keydown", limit_enter_without_sumbit
  $("#category-item-add").on "keydown", limit_enter_without_sumbit
  $("#tag-input").on "keydown", limit_enter_without_sumbit
)