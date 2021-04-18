# frozen_string_literal: true

FactoryBot.define do
  factory(:target, class: "Check::Target") do
    check { association(:check, target: instance) }

    trait(:refreshable) do
      next_refresh_at { 1.day.ago }
    end
  end
end
