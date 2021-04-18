# frozen_string_literal: true

FactoryBot.define do
  factory(:check, class: "Test::Check") do
    transient do
      count_value { nil }
      target_delta { 0 }
      target_value { 0 }
    end

    integration { default_integration }
    sequence(:name, 100) { |n| "Test Check #{n}" }
    target_attributes { { value: target_value, delta: target_delta } }
    user { integration.user }

    after(:create) do |check, evaluator|
      # https://github.com/rails/rails/issues/41827
      check.instance_variable_set(:@strict_loading, false)

      if evaluator.count_value
        count = create(:count, check: check, value: evaluator.count_value)
        check.update!(latest_count: count)
      end
    end
  end
end
