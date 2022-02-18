# frozen_string_literal: true

FactoryBot.define do
  factory(:check, class: "Test::Check") do
    transient do
      value { nil }
      target_delta { 0 }
      target_value { 0 }
    end

    integration { default_integration }
    sequence(:name, 100) { |n| "Test Check #{n}" }
    target_attributes { { value: target_value, delta: target_delta } }
    user { integration.user }

    after(:create) do |check, evaluator|
      if evaluator.value
        count = create(:count, check: check, value: evaluator.value)
        check.update!(latest_count: count)
      end
    end
  end
end
