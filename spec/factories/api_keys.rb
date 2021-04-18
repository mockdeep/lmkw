# frozen_string_literal: true

FactoryBot.define do
  factory(:api_key) do
    user { default_user }
    sequence(:name, 100) { |n| "Test API Key #{n}" }
  end
end
