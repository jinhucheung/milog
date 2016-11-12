# ajax请求表单
# 添加文章分类请求
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

# 删除文章分类请求
this.aj_delete_category = {
  url: '/categories/:id',
  type: 'DELETE',
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
  category_id: (id)->
    this.url = '/categories/'+id 
}

# 更新文章分类请求
this.aj_update_category = {
  url: '/categories/:id',
  type: 'PATCH',
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
  category_id: (id)->
    this.url = '/categories/'+id 
}