#= require ajax_form

# 文章分类处理
category_handler = ()->
  # 文章分类项设置操作
  setting_category_item = ()->
    $(".post-category-menu").on "click", ".category-item .setting", ()-> 
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
      $("#category-error").css("display", "none")
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
          $.ajax(aj_add_category)

  # 菜单隐藏时隐藏错误信息
  categories_menu_on_hide = ()->
    $(".post-category").on "hide.bs.dropdown", ()->
      $("#category-error").css("display", "none")
      $("#category-item-add").val ""

  # 注册事件
  setting_category_item()
  select_category_item()
  add_category_item()
  categories_menu_on_hide()

# load
$(()->
  category_handler()
)

