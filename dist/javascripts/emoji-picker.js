 //选择区一页最大48个,多于48后出现滚动条
 var $emoji_picker_apage_maxnum = 48;
 // 编辑区
 var $editor = document.getElementById('editor');
 
 /* emoji选择辅助 */
 function emoji_helper () {
 			var helper = new Object;
 			// 表情集合
 		  helper.people = new Array("grinning","grin","joy","smiley","smile","sweat_smile","laughing","innocent","smiling_imp","imp","blush","wink","relaxed","yum","relieved","heart_eyes","sunglasses","smirk","neutral_face","expressionless","unamused","sweat","pensive","confused","confounded","kissing","kissing_heart","kissing_smiling_eyes","kissing_closed_eyes","stuck_out_tongue","stuck_out_tongue_winking_eye","stuck_out_tongue_closed_eyes","disappointed","worried","angry","rage","cry","persevere","triumph","disappointed_relieved","frowning","anguished","fearful","weary","sleepy","tired_face","grimacing","sob","open_mouth","hushed","cold_sweat","scream","astonished","flushed","sleeping","dizzy_face","no_mouth","mask","joy_cat","smiley_cat","heart_eyes_cat","smirk_cat","kissing_cat","pouting_cat","crying_cat_face","scream_cat","bust_in_silhouette","busts_in_silhouette","baby","boy","girl","man","woman","guardsman","princess","construction_worker","cop","older_woman","older_man","man_with_turban","man_with_gua_pi_mao","person_with_blond_hair","bride_with_veil","dancers","two_women_holding_hands","two_men_holding_hands","couple","family","angel","santa","ghost","japanese_ogre","japanese_goblin","hankey","skull","alien","space_invader","bow","information_desk_person","no_good","ok_woman","raising_hand","person_with_pouting_face","person_frowning","massage","haircut","couple_with_heart","couplekiss","raised_hands","clap","hand","ear","eyes","nose","lips","kiss","tongue","nail_care","open_hands","muscle","raising_hand","fist","facepunch","v","ok_hand","point_right","point_left","point_down","point_up_2","point_up","-1","wave","pray","question","anger","100" );
 		  helper.nature = new Array("zap","fire","sunny","partly_sunny","cloud","droplet","sweat_drops","umbrella","dash","snowflake","star2","star","stars","sunrise_over_mountains","sunrise","rainbow","ocean","volcano","milky_way","mount_fuji","japan","globe_with_meridians","earth_africa","earth_americas","earth_asia","new_moon","waxing_crescent_moon","first_quarter_moon","moon","full_moon","waning_gibbous_moon","last_quarter_moon","waning_crescent_moon","new_moon_with_face","full_moon_with_face","first_quarter_moon_with_face","last_quarter_moon_with_face","sun_with_face","waxing_gibbous_moon","sunny","seedling","evergreen_tree","deciduous_tree","palm_tree","cactus","tulip","cherry_blossom","rose","hibiscus","sunflower","blossom","bouquet","ear_of_rice","herb","four_leaf_clover","maple_leaf","fallen_leaf","leaves","mushroom","chestnut","rat","mouse2","mouse","hamster","ox","water_buffalo","cow2","cow","tiger2","leopard","tiger","rabbit2","rabbit","cat2","cat","racehorse","horse","ram","sheep","goat","rooster","chicken","baby_chick","hatching_chick","hatched_chick","bird","elephant","penguin","dromedary_camel","camel","boar","pig2","pig","pig_nose","dog2","poodle","dog","wolf","bear","koala","panda_face","monkey_face","see_no_evil","speak_no_evil","monkey","dragon","dragon_face","crocodile","snake","turtle","frog","whale2","whale","dolphin","octopus","fish","tropical_fish","blowfish","shell","snail","bug","ant","bee","beetle","feet");
 		  helper.celebration = new Array("ribbon","gift","birthday","jack_o_lantern","christmas_tree","tanabata_tree","bamboo","rice_scene","fireworks","sparkler","tada","confetti_ball","balloon","dizzy","sparkles","heartbeat","revolving_hearts","two_hearts","love_letter","broken_heart","heart","heartpulse","sparkling_heart","cupid","gift_heart","heart_decoration","purple_heart","yellow_heart","green_heart","blue_heart","ring","izakaya_lantern","crossed_flags","wind_chime","flags","dolls","crown","mortar_board","boom","tomato","eggplant","corn","sweet_potato","grapes","melon","watermelon","tangerine","lemon","banana","pineapple","apple","green_apple","pear","peach","cherries","strawberry","hamburger","pizza","meat_on_bone","poultry_leg","rice_cracker","rice_ball","ramen","spaghetti","dango","oden","sushi","fried_shrimp","fish_cake","icecream","shaved_ice","ice_cream","doughnut","cookie","chocolate_bar","candy","lollipop","custard","honey_pot","cake","bento","stew","egg","fork_and_knife","tea","coffee","sake","wine_glass","cocktail","tropical_drink","beer","beers","baby_bottle");
 		  helper.activity = new Array("runner","walking","dancer","rowboat","swimmer","surfer","bath","snowboarder","ski","snowman","bicyclist","mountain_bicyclist","horse_racing","tent","fishing_pole_and_fish","soccer","basketball","football","baseball","tennis","rugby_football","golf","trophy","running_shirt_with_sash","checkered_flag","musical_keyboard","guitar","violin","saxophone","trumpet","musical_note","notes","musical_score","headphones","microphone","performing_arts","ticket","tophat","circus_tent","clapper","art","dart","8ball","bowling","slot_machine","game_die","video_game","flower_playing_cards","black_joker","mahjong","carousel_horse","ferris_wheel","roller_coaster","bow_and_arrow","crossed_swords","golfer","ice_skate","skier","stadium","volleyball");
 		  helper.objects = new Array("grinning");
 		  helper.symbols = new Array("grinning");


 		  helper.select = function (type){
 					return eval("helper."+type); // 返回指定类型的emoji表情数组
 			};
 			return helper;
 }
 var $emoji_helper=emoji_helper();


 /* Emoji表情选择区出现滚动条时,调整区域宽度 */
 function adjustEmojiContentWidth() {
     var emoji_items = $(".emoji-item");
     if (emoji_items.length > $emoji_picker_apage_maxnum || hasScrolled($(".emoji-content")[0])) {
         emoji_items.each(function() {
             $(this).css("margin", "1px 4px");
         });
     } else {
         emoji_items.each(function() {
             $(this).css("margin", "1px 3px");
         });
     }
 }

 /* 构建emoji表情项 */
 function build_emoji_item(title) {
 		 return  '<a href="#" class="emoji-item em em-' + title + '" title=":'+ title +':"></a>';
 }
 function build_emoji_items(type) {
 	  var result= "";
 		var items = $emoji_helper.select(type);
 		for (var i = 0; i < items.length; i++) {
 			  result += build_emoji_item(items[i]);
 		}
 		return result;
 }

 /* 表情标签页点击处理 */
 $("ul.emoji-menu-tabs").on("click", "[data-stopPropagation]", function(e) {
     $(".emoji-menu-tab.active").removeClass("active"); //清除激活样式
     var parent = $(this).parent();
     parent.addClass("active");
     e.stopPropagation(); // 表情分页标签点击不关闭菜单 
     adjustEmojiContentWidth();

     // 表情选择区切换
     $(".emoji-content .active").css("display","none").removeClass("active"); // 隐藏之前选中项对应区域
     var tabType = $(this).attr("data-type");  //将要显示的区域
     var current = $(".emoji-content .emoji-group-"+tabType);
     current.css("display","").addClass("active");
     // 之前没构建标签项则开始构建
     if (!(current.children(".emoji-item")[0])) {
    	  current.html(build_emoji_items(tabType));
   		}
 });

 /* 插入emoji表情符号 */
 $(".emoji-picker").on("click", ".emoji-item", function() {
     insert_at_cursor($editor, $(this).attr("title"), 0, 0);
 })
