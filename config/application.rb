require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Uzhindoma
  class Application < Rails::Application
    config.assets.precompile << 'delayed/web/application.css'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.days_of_week = {	"1" => "Понедельник",
							"2" => "Вторник",
							"3" => "Среда",
							"4" => "Четверг",
							"5" => "Пятница",
							"6" => "Суббота",
							"7" => "Воскресенье"}
    config.active_job.queue_adapter = :delayed_job
  end
end
