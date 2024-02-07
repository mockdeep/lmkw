# frozen_string_literal: true

require "capybara/rails"
require "capybara-screenshot/rspec"

require_relative "capybara/rack_test"

Capybara.server = :puma, { Silent: true }
Capybara.register_driver(:chrome, &Capybara.drivers[:selenium_chrome])
Capybara.register_driver(:firefox, &Capybara.drivers[:selenium])
Capybara.save_path = ENV.fetch("CIRCLE_ARTIFACTS", Capybara.save_path)

driver = ENV.fetch("DRIVER", :firefox).to_sym

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by(driver)
  end

  config.before(:each, type: :controller) do
    Capybara.default_normalize_ws = true
  end

  config.after(:each, type: :controller) do
    Capybara.default_normalize_ws = false
  end
end
