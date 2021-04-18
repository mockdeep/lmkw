# frozen_string_literal: true

require_relative "factories/api_keys"

RSpec.configure do |config|
  config.include(Factories)
end
