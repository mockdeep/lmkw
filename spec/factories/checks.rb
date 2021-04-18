# frozen_string_literal: true

FactoryBot.define do
  factory(:check, class: "Test::Check") do
    integration { default_integration }
    sequence(:name, 100) { |n| "Test Check #{n}" }
    target_attributes { {} }
    user { integration.user }

    after(:create) do |check|
      # https://github.com/rails/rails/issues/41827
      check.instance_variable_set(:@strict_loading, false)
    end
  end
end
