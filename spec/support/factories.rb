# frozen_string_literal: true

require_relative "factories/api_keys"
require_relative "factories/requests"

module Factories
  def create_check(counts:, target:)
    create(
      :check,
      count_values: counts.pluck(:value),
      target_attributes: target,
    )
  end
end

RSpec.configure do |config|
  config.include(Factories)
end
