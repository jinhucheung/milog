require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Milog
  class Application < Rails::Application
    config.i18n.default_locale="zh-CN"
  end
end
