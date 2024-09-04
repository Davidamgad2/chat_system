# config/initializers/sidekiq.rb

require "sidekiq"
require "sidekiq-scheduler"

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = File.expand_path("../../sidekiq.yml", __FILE__)
    if File.exist?(schedule_file)
      Sidekiq.schedule = YAML.load_file(schedule_file)[:scheduler][:schedule]
      Sidekiq::Scheduler.reload_schedule!
    else
      Rails.logger.error("Sidekiq schedule file not found: #{schedule_file}")
    end
  end
end
