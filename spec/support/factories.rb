# frozen_string_literal: true

require_relative "factories/api_keys"
require_relative "factories/requests"

module Factories
  def create_check(counts:, target: {})
    check = create(:check, target_attributes: target)
    create_counts(check, counts)
    check
  end

  def create_manual_check(counts: [], target: {})
    check = create(:manual_check, target_attributes: target)
    create_counts(check, counts)
    check
  end

  def create_counts(check, counts)
    created_counts =
      counts.map do |count_params|
        create(:count, check: check, **count_params)
      end
    check.update!(latest_count: created_counts.last)
    created_counts
  end

  TARGET_TRAITS = {
    refreshable: -> { { next_refresh_at: 1.day.ago } },
  }.freeze

  def create_target(*traits, **attributes)
    traits.each { |trait| attributes.merge!(TARGET_TRAITS.fetch(trait).call) }
    create(:check, target_attributes: attributes).target
  end

  def next_id
    @next_id ||= 0
    @next_id += 1
  end
end

RSpec.configure do |config|
  config.include(Factories)
end
