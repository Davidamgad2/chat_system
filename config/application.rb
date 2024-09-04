require_relative "boot"

require "rails"

%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  active_job/railtie
  action_cable/engine
  action_worker/railtie
  rails/test_unit/railtie
  sprockets/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Rails.load if defined?(Dotenv::Rails)

module ChatSystem
  class Application < Rails::Application
    config.load_defaults 7.2
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += %W(#{config.root}/app/workers)
  end
end
