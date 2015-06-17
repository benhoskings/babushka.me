require File.expand_path('../boot', __FILE__)

require "rails"
require "action_controller/railtie"

Bundler.require(:default, Rails.env) if defined?(Bundler)

module BabushkaMe

  REFSPEC = `git rev-parse --short HEAD 2>/dev/null`.strip

  class Application < Rails::Application
    config.autoload_paths += %W[#{config.root}/lib]
    config.filter_parameters += [:password]
  end
end
