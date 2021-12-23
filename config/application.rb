# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LetMeKnowWhen
end

# Configuration for the application, engines, and railties goes here.
#
# These settings can be overridden in specific environments using the files
# in config/environments, which are processed later.
#
# config.time_zone = "Central Time (US & Canada)"
# config.eager_load_paths << Rails.root.join("extras")
class LetMeKnowWhen::Application < Rails::Application
  # Initialize configuration defaults for originally generated Rails version.
  config.load_defaults(6.1)

  # Configuration for the application, engines, and railties goes here.
  #
  # These settings can be overridden in specific environments using the files
  # in config/environments, which are processed later.
  #
  # config.time_zone = "Central Time (US & Canada)"
  # config.eager_load_paths << Rails.root.join("extras")

  config.active_job.queue_adapter = :sidekiq

  config.active_record.belongs_to_required_by_default = false

  extra_paths = [
    Rails.root.join("app/models/nulls"),
    Rails.root.join("lib/route_constraints"),
  ]
  config.autoload_paths += extra_paths
  config.eager_load_paths += extra_paths

  config.action_mailer.deliver_later_queue_name = :default
end
