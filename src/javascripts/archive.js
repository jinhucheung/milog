/* 归档文章项悬停时, 高亮显示 */
$("#posts-collection .post").each(function(){
		$(this).hover(function(){
				$(this).children(".post-header").toggleClass("post-header-hover-on");
		});
});