# frozen_string_literal: true

FactoryBot.define do
  factory(:github_integration, class: "Integration::Github") do
    user { default_user }
    sequence(:access_token) { |n| "foo-token-#{n}" }
  end
end
