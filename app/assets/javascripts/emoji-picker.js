 //选择区一页最大48个,多于48后出现滚动条
 var $emoji_picker_apage_maxnum = 48;
 // 编辑区
 var $editor = document.getElementById('editor');
 
 /* emoji选择辅助 */
 function emoji_helper () {
 		  var helper = new Object;
 		  // 表情集合
          helper.recent = new Array(); 
 		  helper.people = new Array("grinning","grin","joy","smiley","smile","sweat_smile","laughing","innocent","smiling_imp","imp","blush","wink","relaxed","yum","relieved","heart_eyes","sunglasses","smirk","neutral_face","expressionless","unamused","sweat","pensive","confused","confounded","kissing","kissing_heart","kissing_smiling_eyes","kissing_closed_eyes","stuck_out_tongue","stuck_out_tongue_winking_eye","stuck_out_tongue_closed_eyes","disappointed","worried","angry","rage","cry","persevere","triumph","disappointed_relieved","frowning","anguished","fearful","weary","sleepy","tired_face","grimacing","sob","open_mouth","hushed","cold_sweat","scream","astonished","flushed","sleeping","dizzy_face","no_mouth","mask","joy_cat","smiley_cat","heart_eyes_cat","smirk_cat","kissing_cat","pouting_cat","crying_cat_face","scream_cat","bust_in_silhouette","busts_in_silhouette","baby","boy","girl","man","woman","guardsman","princess","construction_worker","cop","older_woman","older_man","man_with_turban","man_with_gua_pi_mao","person_with_blond_hair","bride_with_veil","dancers","two_women_holding_hands","two_men_holding_hands","couple","family","angel","santa","ghost","japanese_ogre","japanese_goblin","hankey","skull","alien","space_invader","bow","information_desk_person","no_good","ok_woman","raising_hand","person_with_pouting_face","person_frowning","massage","haircut","couple_with_heart","couplekiss","raised_hands","clap","hand","ear","eyes","nose","lips","kiss","tongue","nail_care","open_hands","muscle","raising_hand","fist","facepunch","v","ok_hand","point_right","point_left","point_down","point_up_2","point_up","-1","wave","pray","question","anger","100" );
 		  helper.nature = new Array("zap","fire","sunny","partly_sunny","cloud","droplet","sweat_drops","umbrella","dash","snowflake","star2","star","stars","sunrise_over_mountains","sunrise","rainbow","ocean","volcano","milky_way","mount_fuji","japan","globe_with_meridians","earth_africa","earth_americas","earth_asia","new_moon","waxing_crescent_moon","first_quarter_moon","moon","full_moon","waning_gibbous_moon","last_quarter_moon","waning_crescent_moon","new_moon_with_face","full_moon_with_face","first_quarter_moon_with_face","last_quarter_moon_with_face","sun_with_face","waxing_gibbous_moon","sunny","seedling","evergreen_tree","deciduous_tree","palm_tree","cactus","tulip","cherry_blossom","rose","hibiscus","sunflower","blossom","bouquet","ear_of_rice","herb","four_leaf_clover","maple_leaf","fallen_leaf","leaves","mushroom","chestnut","rat","mouse2","mouse","hamster","ox","water_buffalo","cow2","cow","tiger2","leopard","tiger","rabbit2","rabbit","cat2","cat","racehorse","horse","ram","sheep","goat","rooster","chicken","baby_chick","hatching_chick","hatched_chick","bird","elephant","penguin","dromedary_camel","camel","boar","pig2","pig","pig_nose","dog2","poodle","dog","wolf","bear","koala","panda_face","monkey_face","see_no_evil","speak_no_evil","monkey","dragon","dragon_face","crocodile","snake","turtle","frog","whale2","whale","dolphin","octopus","fish","tropical_fish","blowfish","shell","snail","bug","ant","bee","beetle","feet");
 		  helper.celebration = new Array("ribbon","gift","birthday","jack_o_lantern","christmas_tree","tanabata_tree","bamboo","rice_scene","fireworks","sparkler","tada","confetti_ball","balloon","dizzy","sparkles","heartbeat","revolving_hearts","two_hearts","love_letter","broken_heart","heart","heartpulse","sparkling_heart","cupid","gift_heart","heart_decoration","purple_heart","yellow_heart","green_heart","blue_heart","ring","izakaya_lantern","crossed_flags","wind_chime","flags","dolls","crown","mortar_board","boom","tomato","eggplant","corn","sweet_potato","grapes","melon","watermelon","tangerine","lemon","banana","pineapple","apple","green_apple","pear","peach","cherries","strawberry","hamburger","pizza","meat_on_bone","poultry_leg","rice_cracker","rice_ball","ramen","spaghetti","dango","oden","sushi","fried_shrimp","fish_cake","icecream","shaved_ice","ice_cream","doughnut","cookie","chocolate_bar","candy","lollipop","custard","honey_pot","cake","bento","stew","egg","fork_and_knife","tea","coffee","sake","wine_glass","cocktail","tropical_drink","beer","beers","baby_bottle");
 		  helper.activity = new Array("runner","walking","dancer","rowboat","swimmer","surfer","bath","snowboarder","ski","snowman","bicyclist","mountain_bicyclist","horse_racing","tent","fishing_pole_and_fish","soccer","basketball","football","baseball","tennis","rugby_football","golf","trophy","running_shirt_with_sash","checkered_flag","musical_keyboard","guitar","violin","saxophone","trumpet","musical_note","notes","musical_score","headphones","microphone","performing_arts","ticket","tophat","circus_tent","clapper","art","dart","8ball","bowling","slot_machine","game_die","video_game","flower_playing_cards","black_joker","mahjong","carousel_horse","ferris_wheel","roller_coaster");
 		  helper.objects = new Array("train","mountain_railway","railway_car","steam_locomotive","monorail","bullettrain_side","bullettrain_front","train2","metro","light_rail","station","tram","bus","oncoming_bus","trolleybus","minibus","ambulance","fire_engine","police_car","oncoming_police_car","rotating_light","taxi","oncoming_taxi","oncoming_automobile","car","blue_car","truck","articulated_lorry","tractor","bike","busstop","fuelpump","construction","vertical_traffic_light","traffic_light","rocket","helicopter","airplane","seat","anchor","ship","speedboat","boat","aerial_tramway","mountain_cableway","suspension_railway","passport_control","customs","baggage_claim","left_luggage","yen","euro","pound","dollar","statue_of_liberty","moyai","foggy","tokyo_tower","fountain","european_castle","japanese_castle","city_sunrise","city_sunset","bridge_at_night","house","house_with_garden","office","department_store","factory","post_office","european_post_office","hospital","bank","hotel","love_hotel","wedding","watch","iphone","calling","computer","alarm_clock","hourglass_flowing_sand","hourglass","camera","video_camera","movie_camera","tv","radio","pager","telephone_receiver","phone","fax","minidisc","floppy_disk","cd","dvd","vhs","battery","electric_plug","bulb","flashlight","satellite","credit_card","money_with_wings","moneybag","gem","closed_umbrella","pouch","purse","handbag","briefcase","school_satchel","lipstick","eyeglasses","womans_hat","sandal","high_heel","boot","mans_shoe","bikini","dress","kimono","womans_clothes","shirt","necktie","jeans","door","shower","bathtub","toilet","barber","syringe","pill","microscope","telescope","crystal_ball","wrench","hocho","nut_and_bolt","hammer","bomb","smoking","gun","bookmark","newspaper","key","email","incoming_envelope","e-mail","inbox_tray","outbox_tray","package","postal_horn","postbox","mailbox_closed","mailbox","mailbox_with_mail","mailbox_with_no_mail","page_facing_up","page_with_curl","bookmark_tabs","chart_with_upwards_trend","chart_with_downwards_trend","bar_chart","date","calendar","low_brightness","high_brightness","scroll","clipboard","book","notebook","notebook_with_decorative_cover","ledger","closed_book","green_book","blue_book","orange_book","books","card_index","link","paperclip","pushpin","scissors","triangular_ruler","round_pushpin","straight_ruler","triangular_flag_on_post","file_folder","open_file_folder","black_nib","pencil2","memo","lock_with_ink_pen","closed_lock_with_key","lock","unlock","mega","loudspeaker","sound","speaker","mute","zzz","bell","no_bell","thought_balloon","speech_balloon","children_crossing","mag","mag_right","no_entry_sign","no_entry");
 		  helper.symbols = new Array("name_badge","no_pedestrians","do_not_litter","no_bicycles","non-potable_water","underage","no_mobile_phones","accept","ideograph_advantage","white_flower","secret","congratulations","sa","koko","chart","sparkle","eight_spoked_asterisk","negative_squared_cross_mark","white_check_mark","eight_pointed_black_star","vibration_mode","mobile_phone_off","vs","a","b","ab","cl","sos","id","parking","wc","cool","free","new","ng","ok","up","atm","aries","taurus","gemini","cancer","leo","virgo","libra","scorpius","sagittarius","capricorn","aquarius","pisces","restroom","mens","womens","baby_symbol","wheelchair","potable_water","no_smoking","put_litter_in_its_place","arrow_forward","arrow_backward","arrow_up_small","arrow_down_small","fast_forward","rewind","arrow_double_up","arrow_double_down","arrow_right","arrow_left","arrow_up","arrow_down","arrow_upper_right","arrow_lower_right","arrow_lower_left","arrow_upper_left","arrow_up_down","left_right_arrow","arrows_counterclockwise","arrow_right_hook","leftwards_arrow_with_hook","arrow_heading_up","arrow_heading_down","twisted_rightwards_arrows","repeat","repeat_one","zero","one","two","three","four","five","six","seven","eight","nine","keycap_ten","1234","hash","abc","abcd","capital_abcd","information_source","signal_strength","cinema","symbols","heavy_plus_sign","heavy_minus_sign","wavy_dash","heavy_division_sign","heavy_multiplication_x","heavy_check_mark","arrows_clockwise","copyright","currency_exchange","heavy_dollar_sign","curly_loop","loop","part_alternation_mark","exclamation","grey_exclamation","grey_question","interrobang","x","o","end","back","on","top","soon","cyclone","m","ophiuchus","six_pointed_star","beginner","trident","warning","hotsprings","recycle","diamond_shape_with_a_dot_inside","spades","clubs","hearts","diamonds","ballot_box_with_check","white_circle","black_circle","radio_button","red_circle","large_blue_circle","small_red_triangle","small_red_triangle_down","small_orange_diamond","small_blue_diamond","large_orange_diamond","large_blue_diamond","black_small_square","white_small_square","white_large_square","black_medium_square","white_medium_square","black_medium_small_square","white_medium_small_square","black_square_button","white_square_button","clock1","clock2","clock3","clock4","clock5","clock6","clock7","clock8","clock9","clock10","clock11","clock12","clock130","clock230","clock330","clock430","clock530","clock630","clock730","clock830","clock930","clock1030","clock1130","clock1230");


 		  helper.select = function (type){
 					return eval("helper."+type); // 返回指定类型的emoji表情数组
 		  };
 		  return helper;
 }
 var $emoji_helper=emoji_helper();


 /* 构建emoji表情项 */
 function build_emoji_item(title) {
 		 return  '<i class="emoji-item em em-' + title + '" title=":'+ title +':"></i>';
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

     // 表情选择区切换
     $(".emoji-content .active").css("display","none").removeClass("active"); // 隐藏之前选中项对应区域
     var tabType = $(this).attr("data-type");  //将要显示的区域
     var current = $(".emoji-content .emoji-group-"+tabType);
     current.css("display","").addClass("active");

     // 之前没构建标签项 或用户最近使用项 则开始构建 
     if (!(current.children(".emoji-item")[0]) || tabType == "recent") {
    	  current.html(build_emoji_items(tabType));
   	  }
 });

 /* 插入emoji表情符号 */
 $(".emoji-picker").on("click", ".emoji-item", function() {
     var title = $(this).attr("title");
     insert_at_cursor($editor, title, 0, 0);
     title = title.replace(':','').replace(':','');
     for (var i = 0; i < $emoji_helper.recent.length; i++) {
         if ($emoji_helper.recent[i] == title) return ;
     }
     $emoji_helper.recent.push(title) ;
     return false; 
 });
