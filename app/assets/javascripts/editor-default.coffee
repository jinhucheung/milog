# 文章分类处理
category_handler = ()->
  # 文章分类项删除操作
  delete_category_item = ()->
    $(".post-category-menu").on "click", ".category-item .delete", ()-> 
      $category_item = $(this).parent().parent()
      $selected_item = $(this).prev(".content").html() # 暂存删除分类内容
      # 正在显示的分类与删除的分类相同
      if $("#post-selected-category").html() == $selected_item
        $(".category-item").first().click()  # 选中默认分类
      $category_item.remove()
      return false

  # 文章分类项选中操作
  select_category_item = ()->
    $(".post-category-menu").on "click", ".category-item", ()->
      # 切换选中项
      $post_category_selected_li = $(".post-category-menu .category-item.li-active") # 当前已选中的分类项
      $post_category_selected_li.removeClass("li-active")
      $post_category_selected_li = $(this)
      $post_category_selected_li.addClass "li-active"
      # 显示选中项
      $selected_item = $(this).children("a").first().find(".content")
      $("#post-selected-category").html $selected_item.html()
      $("#post-selected-category-input").attr "value", $selected_item.attr("value") # 更新分类input的值

  # 构建文章分类项
  build_category_item = ($category_name)->
    return "<li class='category-item'>" + #
           "   <a>" + #
           "     <span class='content'>" + $category_name + "</span>" + #
           "     <span class='delete' role='button'>x</span>" + #
           "   </a>" + #
           "</li>"

  # 添加文章分类项
  add_category_item = ()->
    $("#category-item-add").on "keydown", (e)-> 
      # 监听用户是否按下Enter
      if e.which == 13 
        $category_name = $(this).val()
        if $category_name && $category_name != "" 
          $.ajax({
            type: 'POST',
            url: '/categories',
            data: { category: { name: $category_name } },
            success: (data)->
              console.log data
              $category_item = build_category_item data["name"]
              $("#category-item-add-li").before $category_item
              $("#category-error").css("display", "none").text ""
              $(this).val ""
              return false
            error: (data)->
              console.log data
              console.log  $("#category-error")
              $("#category-error").css("display", "block").text data.responseText
              return false
          })


  # 注册事件
  delete_category_item()
  select_category_item()
  add_category_item()

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
  $("#tab-input").on "keyup", ()->
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

# 输入框Enter后禁止提交
limit_enter_without_sumbit = ($event)->
  if $event.keyCode == 13
    $event.preventDefault()
    return false

# load
$(()->
  category_handler()
  editor_sytle_handler()
  tag_input_handler()
  $("#title-input").on "keydown", limit_enter_without_sumbit
  $("#category-item-add").on "keydown", limit_enter_without_sumbit
  $("#tab-input").on "keydown", limit_enter_without_sumbit
)