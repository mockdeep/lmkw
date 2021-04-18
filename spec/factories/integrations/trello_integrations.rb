# frozen_string_literal: true

FactoryBot.define do
  factory(:trello_integration, class: "Integration::Trello") do
    user { default_user }
    sequence(:member_token) { |n| "foo-token-#{n}" }
  end
end
