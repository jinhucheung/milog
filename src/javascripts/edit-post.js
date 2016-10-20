$(function() {
    /* 文章分类项选中,处理 */
    function select_category_item() {
        $(".category-item").on("click", function() {
            // 切换选中项
            $post_category_selected_li.removeClass("li-active");
            $post_category_selected_li = $(this);
            $post_category_selected_li.addClass("li-active");
            // 显示选中项
            var $selected_item = $(this).children("a").first().find(".content").html();
            $("#post-selected-category").html($selected_item);
            $("#post-selected-category-input").attr("value", $selected_item); //更新分类input的值
        });
    };
    var $post_category_selected_li = $(".post-category-menu .category-item.li-active"); //已选中的分类项
    select_category_item();


    /* 文章分类项删除操作 */
    function delete_category_item() {
        $(".category-item").each(function() {
            var $category_item = $(this);
						var $selected_item = $(this).children("a").first().find(".content").html();  //暂存删除分类内容
            $(this).find(".delete").click(function() {
            		//正在显示的分类与删除的分类相同
           		 if ( $("#post-selected-category").html() == $selected_item) {
            	 		$("#post-selected-category").html("");  //置空
            		  $("#post-selected-category-input").attr("value", "");
           		 }
               $category_item.remove();
            });

        });
    };
    delete_category_item();


    /* 构建文章分类项 */
    function build_category_item($category_name) {
        return "<li class='category-item'>" + //
            	 " 	<a>" + //
               "     <span class='content'>" + $category_name + "</span>" + //
               "     <span class='delete' role='button'>x</span>" + //
               "	</a>" + //
               "</li>";
    }

    /* 添加文章分类项 */
    $("#category-item-add").on("keydown", function(e) {
        /* 监听用户是否按下Enter*/
        if (e.which == 13) {
            $category_name = $(this).val();
            if ($category_name && $category_name != "") {
                $category_item = build_category_item($category_name);
                $("#category-item-add-li").before($category_item);
                $(this).val("");
                select_category_item();
                delete_category_item();
            }
        }
    });
});
