# frozen_string_literal: true

FactoryBot.define do
  factory(:target, class: "Check::Target") do
    transient do
      count_values { [] }
    end

    check { association(:check, target: instance, count_values: count_values) }

    trait(:refreshable) do
      next_refresh_at { 1.day.ago }
    end
  end
end
