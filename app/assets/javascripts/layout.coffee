# back-to-top 回到页面顶部 //需导入velocity.js
THRESHOLD = 50
$top = $('.back-to-top')
$(window).on 'scroll', ()->
  $top.toggleClass 'back-to-top-on', window.pageYOffset > THRESHOLD

$top.on 'click', ()->
  $('body').velocity 'scroll'  
