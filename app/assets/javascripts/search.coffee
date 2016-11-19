# 显示搜索对话框
$("#search").on "click", ()->
  $("#search-dialog").modal()
  return false

# 输入框焦点改变时,改变其包含图标颜色
$('#search_in_keyword').focus ()->
  $(this).next(".icon").css "color", "#444"
$('#search_in_keyword').blur ()->
  $(this).next(".icon").css "color", ""

# 发送请求前拦截空字段
$('#search_in_keyword').on 'keydown', (e)->
  keyword = $(this).val()
  if e.keyCode == 13 && keyword == ""
    return false
    
# 重置搜索对话框状态
$("#search-dialog").on "hidden.bs.modal", ()->
  $('#search_in_keyword').val ""
  $("#no-result").css "display", "block"
  $("#no-result i").addClass "fa-search"
  $("#no-result i").removeClass "fa-frown-o"
  $("#search-result #result").remove()
  return true

# 当点击文章链接后, 销毁对话框
$("#search-result").on 'click', '#result .title', ()-> 
  $(".modal-header .close").click()
  return true