require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SomlengScfm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    if Rails.env.production? && ENV["ACTIVE_JOB_ADAPTER"] == "active_elastic_job"
      config.active_job.queue_adapter = :active_elastic_job
    end

    # Don't generate system test files.
    config.generators.system_tests = nil

    host = ENV.fetch("SOMLENG_SCFM_HOST") { "localhost" }
    port = ENV.fetch("SOMLENG_SCFM_PORT") { "3000" }
    config.action_mailer.default_url_options = { :host => host, :port => port }

    # From https://blog.bigbinary.com/2016/02/26/rails-5-allows-configuring-queue-name-for-mailers.html
    # config.action_mailer.deliver_later_queue_name = ApplicationJob.queue_name(:action_mailer_delivery_job)
  end
end
