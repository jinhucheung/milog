#= require ajax_form

# 保存正设置的分类项
this.category_item = {
  obj: null,
  content: null,
  name: null,
  id: null,
  clear: ()->
    this.obj = null
    this.content = null
    this.name = null
    this.id = null
  set: (id, name)->
    this.id = id
    this.name = name
}

# 文章分类处理
category_handler = ()->
  # 显示文章分类项设置操作
  setting_category_item = ()->
    $(".post-category-menu").on "click", ".category-item .setting", ()->
      category_item.obj = $(this).parent().parent()
      category_item.content = $(this).prev(".content")
      category_item.name = category_item.content.text()
      category_item.id = category_item.content.attr "value"
      $("#category-item-setting").val category_item.name
      $("#category-setting").modal()
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
      return false

  # 构建文章分类项
  build_category_item = ($category)->
    return "<li class='category-item'>" + #
           "   <a href='#'>" + #
           "     <span class='content' value="+$category.id+">" +$category.name+ "</span>" + #
           "     <span class='setting fa fa-cog fa-fw' role='button'></span>" + #
           "   </a>" + #
           "</li>"

  # 添加文章分类项
  add_category_item = ()->
    $("#category-item-add").on "keydown", (e)-> 
      # 监听用户是否按下Enter
      if e.which == 13 
        $category_name = $(this).val()
        if $category_name && $category_name != "" 
          aj_add_category.category_name $category_name
          aj_add_category.asuccess = (data)->
            $category_item = build_category_item data.category
            $("#category-item-add-li").before $category_item
            $("#category-error").css("display", "none").text ""
            $(this).val ""
            scroll_on_bottom ".post-category-menu"
          aj_add_category.aerror = (data)->
            $("#category-error").css("display", "block").text data.error
            scroll_on_bottom ".post-category-menu"
          $.ajax aj_add_category

  # 删除文章分类
  delete_category_item = ()->
    $("#category-item-delete").on "click", ()->
      if category_item.id == null
        return
      aj_delete_category.category_id category_item.id
      aj_delete_category.asuccess = (data)->
        $("#category-item-setting").attr "disabled", true
        $("#category-setting #category-tips").css("display", "block").text data.success
        # 删除列表中的分类
        if $("#post-selected-category").text() == category_item.name
          $(".category-item").first().click()  # 选中默认分类
        category_item.obj.remove()
      aj_delete_category.aerror = (data)->
        $("#category-setting #category-tips").css("display", "block").text data.error
      $.ajax aj_delete_category

  # 更新文章分类
  update_category_item = ()->
    $("#category-item-update").on "click", ()->
      if category_item.id == null
        return
      updated_name = $("#category-item-setting").val()
      aj_update_category.category_id category_item.id
      aj_update_category.category_name updated_name
      aj_update_category.asuccess = (data)->
        category = data.category
        category_item.content.attr "value", category.id
        category_item.content.text category.name
        if $("#post-selected-category").text() == category_item.name
          $(".category-item").first().click()  # 选中默认分类
        category_item.set category.id, category.name
        $("#category-setting #category-tips").css("display", "block").text data.success
      aj_update_category.aerror = (data)->
        $("#category-setting #category-tips").css("display", "block").text data.error
      $.ajax aj_update_category

  # 菜单隐藏时隐藏错误信息
  categories_menu_on_hide = ()->
    $(".post-category").on "hide.bs.dropdown", ()->
      $("#category-error").css "display", "none"
      $("#category-item-add").val ""

  # 设置对话框隐藏时初始化状态
  category_setting_dialg_on_hide = ()->
    $("#category-setting").on "hidden.bs.modal", ()->
      category_item.clear
      $("#category-item-setting").attr "disabled", false
      $("#category-setting #category-tips").css "display", "none"

  # 注册事件
  setting_category_item()
  select_category_item()
  add_category_item()
  delete_category_item()
  update_category_item()
  categories_menu_on_hide()
  category_setting_dialg_on_hide()
  $("#category-item-setting").on "keydown", limit_enter_without_sumbit

# load
$(()->
  category_handler()
)

