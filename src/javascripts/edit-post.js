/* 文章分类处理 */
$(function() {
    /* 文章分类项删除操作 */
    function delete_category_item() {
        $(".post-category-menu").on("click", ".category-item .delete", function() {
            $category_item = $(this).parent().parent();
            $selected_item = $(this).prev(".content").html(); //暂存删除分类内容
            //正在显示的分类与删除的分类相同
            if ($("#post-selected-category").html() == $selected_item) {
                $(".category-item").first().click();  //选中默认分类
            }
            $category_item.remove();
            return false; // 阻止事件往上传递
        });
    };

    /* 文章分类项选中操作 */
    function select_category_item() {
        $(".post-category-menu").on("click", ".category-item", function() {
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

    /* 构建文章分类项 */
    function build_category_item($category_name) {
        return "<li class='category-item'>" + //
            "   <a>" + //
            "     <span class='content'>" + $category_name + "</span>" + //
            "     <span class='delete' role='button'>x</span>" + //
            "   </a>" + //
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
            }
        }
    });

    var $post_category_selected_li = $(".post-category-menu .category-item.li-active"); //当前默认已选中的分类项
    delete_category_item();  //注册事件
    select_category_item();
});


/* 文章编辑区样式处理： 正处于编辑区则加深边线 */
$(function(){

    var $edit_tabs = $("#edit-tabs");
    var $edit_tabs_lia = $("#edit-tabs li a");
    var $edit_content = $("#tab-content");

    /* 在编辑区或预览区 则边线加深  */
    /* $tab_index区分编辑区或预览区  */
    function edit_border_deepen($tab_index){
        $edit_tabs.addClass("edit-tabs-border-deepen");
        $edit_content.addClass("edit-cotent-border-deepen");
        $edit_tabs_lia.eq($tab_index).addClass("edit-tab-border-deepen");
    }

    /* 不在编辑区 边线变浅 */
    function edit_border_clear(){
        $edit_tabs.removeClass("edit-tabs-border-deepen");
        $edit_content.removeClass("edit-cotent-border-deepen");
        $edit_tabs_lia.each(function(){ $(this).removeClass("edit-tab-border-deepen"); });
    }

    
    /* 获取编辑区的节点 */
    $(document).click(function(e){
        // 清除之前的边线样式
        edit_border_clear();
        var $edit_node = $(e.target);  // 获取当前页面的点击节点
        if ( $edit_node.is(".edit-body-node") ) {  // 判断是否为编辑区的节点
            var $edit_or_preview = 0;
            if ( $edit_node.is(".edit-node") ) {
                $edit_or_preview = 0;  //是编辑节点
            }else {
                $edit_or_preview = 1;  //是预览节点
            }
            edit_border_deepen($edit_or_preview);
        }
    });
});