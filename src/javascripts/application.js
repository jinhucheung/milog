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