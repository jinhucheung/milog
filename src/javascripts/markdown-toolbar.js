/* 工具项 { name, title } */
var $items = new Array({ name: "bold",title: "强调" }, //
   										 { name: "italic",title: "斜体"}, //
   										 { name: "header",title: "标题"}, //
   										 1, //	分隔线
   										 { name: "quote-left",title: "引用" }, //
   										 { name: "list-ul",title: "无序列表"}, //
   										 { name: "list-ol",title: "有序列表"}, //
   										 { name: "code",title: "代码"}, //
   										 1, //	分隔线
   										 { name: "link",title: "链接"}, //
   										 { name: "image",title: "图片"} //
											);

/* 构建工具项 */
function build_a_item($item) {
		return "<a class='" + "toolbar-item" + " add-" + $item.name +"' "+ //
					 "href='#' " +"title='"+ $item.title +"'>" + //
					 "     <i class='fa fa-" + $item.name + "'></i>" + //
					 "</a>";
}

/* 构建工具栏 */
function build_toolbar(){
		var $toolbar="";
				
		for (i=0; i< $items.length; i++){
				if ( $items[i] == 1) { // 添加分隔线
						 $toolbar += "<span class='divider'></span>";
				} else {
					   $toolbar += build_a_item($items[i]);
				}
		}
		return $toolbar;
}

/* 添加工具栏 */
$(function(){
		$(".mardown-toolbar").append(build_toolbar());
		$(".toolbar-item").on("click",function(){
				console.log($(this).attr("title"));
		});
});

