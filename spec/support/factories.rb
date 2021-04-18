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

  TARGET_TRAITS = {
    refreshable: -> { { next_refresh_at: 1.day.ago } },
  }.freeze

  def create_target(*traits, **attributes)
    traits.each { |trait| attributes.merge!(TARGET_TRAITS.fetch(trait).call) }
    create(:check, target_attributes: attributes).target
  end
end

RSpec.configure do |config|
  config.include(Factories)
end
