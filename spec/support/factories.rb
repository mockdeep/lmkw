# frozen_string_literal: true

require_relative "factories/api_keys"
require_relative "factories/requests"

RSpec.configure do |config|
  config.include(Factories)
end
