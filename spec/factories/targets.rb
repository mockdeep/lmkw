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
  end
end
