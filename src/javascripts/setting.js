$(".avatar-upload").on("click","#upload-avatar-btn",function() {
		$("#upload-avatar-input").click();
});

/* 上传头像 */
$("#upload-avatar-input").change(function(){
		console.log("hello");
		console.log($(this).val());
});