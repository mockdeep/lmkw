# frozen_string_literal: true

FactoryBot.define do
  factory(:manual_integration, class: "Integration::Manual") do
    user { default_user }
  end
end
