# ajax请求表单
# 添加文章分类项请求
this.aj_add_category = {
  url: '/categories',
  type: 'POST',
  data: { category: { name: "" } },
  success: (data)->
    if data.status == 200
      this.asuccess data
    else
      this.aerror data
    return false
  asuccess: (data)->
    return false
  aerror: (data)->
    return false
  category_name: (name)->
    this.data.category.name = name
}