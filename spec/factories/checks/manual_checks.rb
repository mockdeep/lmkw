# frozen_string_literal: true

FactoryBot.define do
  factory(:manual_check, class: "Check::Manual::AnyCount", parent: :check) do
    sequence(:name, 100) { |n| "Manual Check #{n}" }
    integration { default_manual_integration }
  end
end
