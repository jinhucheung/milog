# 显示搜索对话框
$("#search").on "click", ()->
  $("#search-dialog").modal()
  return false

# 输入框焦点改变时,改变其包含图标颜色
$('#search_in_keyword').focus ()->
  $(this).next(".icon").css "color", "#444"
$('#search_in_keyword').blur ()->
  $(this).next(".icon").css "color", ""