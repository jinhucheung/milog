/* 切换语言 */
var $lang=0;  //0-EN 1-中文
$(".switch-lang").click(function(){
		if ( $lang == 0 ) {
				// 切换到EN
				$(this).html("中文");
				$lang = 1;
		} else {
				// 切换到中文
				$(this).html("EN");
				$lang = 0;
		}
});

/* 登出 */
$(".navbar #logout").click(function(){
	 $(".navbar .drop-nav").css("display","none");
	 $(".navbar .login-group").css("display","");
});

/* back-to-top 回到页面顶部 */
var THRESHOLD = 50;
var $top = $('.back-to-top');
$(window).on('scroll', function () {
    $top.toggleClass('back-to-top-on', window.pageYOffset > THRESHOLD);
});
$top.on('click', function () {
  $('body').velocity('scroll');  //需导入velocity.js
});

/* 监听input/textarea输入,将中文逗号转为英文 */
function ReplaceDot($node_id) {
		var $node=$($node_id); 
		var $oldValue=$node.val(); 
		while( $oldValue.indexOf("，") != -1 ) 		{  //寻找每一个中文逗号，并替换 
				$node.val($oldValue.replace("，",",")); 
				$oldValue=$node.val(); 
		} 
}
