# Milog

一基于 [ Ruby on Rails ](https://github.com/rails/rails) 的个人博客网站. http://hijinhu.me/hijinhu/  

Guest Account > Email: aguest@hijinhu.me | Password: 123456

静态页面可访问 https://github.com/HiKumho/milog/tree/static_pages

## 特点

+ 支持[Bootstrap](http://getbootstrap.com/)，实现响应式设计

+ 使用[Markdown](https://zh.wikipedia.org/zh-hans/Markdown)作为编辑文本格式，主要由[Markdown-it](https://github.com/markdown-it/markdown-it)在客户端进行解析渲染，[motion-markdown-it](https://github.com/digitalmoksha/motion-markdown-it)负责后端解析

+ Markdown支持[Emoji 表情](https://github.com/afeld/emoji-css)

+ 实现Markdown工具栏

+ 使用[bcrypt](https://github.com/codahale/bcrypt-ruby)加密用户重要资料

+ 可暂存用户编辑中的文本

+ [Elasticsearch](https://github.com/elastic/elasticsearch)作为全文搜索引擎，可根据关键字搜索文章

+ 支持上传图片，使用[七牛](http://www.qiniu.com/)存储

## 更新

### 2016年12月20日

+ 增加社区模块

+ 修改用户主页，增加用户关注功能

+ 增加消息通知系统

### 2017年1月30日

+ 使用 [Letter Avatar](https://github.com/ksz2k/letter_avatar) ，代替原本的用户默认头像模块

+ 使用 [Rails Settings Cached](https://github.com/huacnlee/rails-settings-cached) 保存系统设置

### 2017年3月14日

+ 释出 Milog Android 客户端 [Milog-Android](https://github.com/HiKumho/milog-android)

+ 修复文章中图片尺寸过大，溢出页面

## Thanks

+ [Ruby on Rails](http://rubyonrails.org/)

+ [Ruby China](https://ruby-china.org/)

+ [Hexo-theme-next](https://github.com/iissnan/hexo-theme-next)

+ [Bootstrap](http://getbootstrap.com/)

+ [Markdown-it](https://github.com/markdown-it/markdown-it)

+ [Elasticsearch](https://github.com/elastic/elasticsearch)

## 部署

### 环境
```
Ubuntu 14.04 / Git / Ruby 2.3.1 / Rails 5.0.0 / MariaDB 5.5.52
```

### 下载
```
git clone git@github.com:Hikumho/milog.git
```

### 数据库

安装[MariaDB](https://mariadb.org/)

```sh
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main'

sudo apt-get update
sudo apt-get install mariadb-server
```

项目配置

在Milog项目下，新建`config/local_env.yml`， 并写入
```
MYSQL_USERNAME: yourname
MYSQL_PASSWORD: yourpassword
```

### 安装Gem

```
bundle install
```

这里可能会由于本地没有安装[imagemagick](https://github.com/ImageMagick/ImageMagick) 或 [elasticsearch](https://www.elastic.co/)出现错误

+ 安装imagemagick： `sudo apt-get install imagemagick`

+ 安装elasticsearch： [教程](https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-on-an-ubuntu-vps)

### 迁移数据

```
rails db:create

rails db:migrate

rails db:seed
```

至此， 项目可在开发环境中运行

## 其它

### 邮件服务
新建`config/email.yml`文件， 写下

```
production:
  address: "smtp.163.com"
  port: 25
  authentication: "plain"
  user_name: "youremail"
  password: "yourpassword"
  enable_starttls_auto: true
```

这里使用的是163的个人邮箱

### 文件上传
使用的是七牛的服务， 具体配置请看[carrierwave-qiniu](https://github.com/huobazi/carrierwave-qiniu)

需在`config/local_env.yml`写下

```
QINIU_ACCESS_KEY: your_access_key
QINIU_SECRET_KEY: your_secret_key
QINIU_BUCKET: your_bucket
QINIU_BUCKET_DOMAIN: your_bucket_domain
```
