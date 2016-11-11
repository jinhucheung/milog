# back-to-top 回到页面顶部 //需导入velocity.js
THRESHOLD = 50
$top = $('.back-to-top')
$(window).on 'scroll', ()->
  $top.toggleClass 'back-to-top-on', window.pageYOffset > THRESHOLD

$top.on 'click', ()->
  $('body').velocity 'scroll'  

# 滚动到元素底部
this.scroll_on_bottom = (selector)->
  $(selector).scrollTop $(selector)[0].scrollHeight
