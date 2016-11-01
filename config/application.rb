require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Milog
  class Application < Rails::Application
    config.i18n.default_locale = 'zh-CN'

    config.before_configuration do 
    	# 读入环境变量
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do | key, value |
      	 ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.generators do |g|
      # 关闭自动生成的rspecs(除model)
      g.controller_specs false
      g.helper_specs false
      g.view_specs false
      g.routing_specs false
      g.request_specs false
    end
  end
end
