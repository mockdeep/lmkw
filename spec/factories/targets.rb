# frozen_string_literal: true

FactoryBot.define do
  factory(:target, class: "Check::Target") do
    transient do
      check_value { nil }
    end

    check { association(:check, target: instance, value: check_value) }

    trait(:refreshable) do
      next_refresh_at { 1.day.ago }
    end

    trait(:unreached_goal) do
      check_value { 5 }
      delta { 1 }
      value { check_value }
    end
  end
end
