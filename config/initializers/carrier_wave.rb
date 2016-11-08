#!/usr/bin/env ruby
# encoding: utf-8

if Rails.env.production?
  CarrierWave.configure do |config|
    # 七牛云配置
    config.storage             = :qiniu
    config.qiniu_access_key    = ENV['QINIU_ACCESS_KEY']
    config.qiniu_secret_key    = ENV['QINIU_SECRET_KEY']
    config.qiniu_bucket        = ENV['QINIU_BUCKET']
    config.qiniu_bucket_domain = ENV['QINIU_BUCKET_DOMAIN']
    config.qiniu_bucket_private= true 
    config.qiniu_block_size    = 4*1024*102
    config.qiniu_protocol      = "http"
  end
end
