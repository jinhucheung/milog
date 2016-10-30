$(".tab .signin a").click ()->
  # 点击login标签,显示下划线 
  $(this).addClass "under-line"
  $(".tab .signup a").removeClass "under-line"
  # 切换注册表单显示
  $("#signup-box").css "display", "none"
  $("#signin-box").css "display", "block"
  return false;

$(".tab .signup a").click ()->
  $(this).addClass "under-line" 
  $(".tab .signin a").removeClass "under-line"
  # 切换登录表单显示
  $("#signup-box").css "display", "block"
  $("#signin-box").css "display", "none"
  return false;

# 输入框焦点改变时,改变其包含图标颜色
$(".login-body .form-group .form-input").each ()->
  $(this).focus ()->
    $(this).next(".icon").css "color", "#444" 	
  $(this).blur ()->
    $(this).next(".icon").css "color", ""
