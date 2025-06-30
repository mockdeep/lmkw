# frozen_string_literal: true

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)

if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

require "rspec/rails"
require "sidekiq/testing"

require_relative "support/assets"
require_relative "support/capybara"
require_relative "support/factory_bot"
require_relative "support/fake_apis_rails"
require_relative "support/helpers"
require_relative "support/shoulda_matchers"
require_relative "support/test_models"

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join("/spec/fixtures")]

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.render_views

  config.include(ActiveSupport::Testing::TimeHelpers)
  config.include(Helpers::General)
  config.include(Helpers::Controller, type: :controller)
  config.include(Helpers::Request, type: :request)
  config.include(Helpers::System, type: :system)
end
