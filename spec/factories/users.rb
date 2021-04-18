# frozen_string_literal: true

FactoryBot.define do
  factory(:user) do
    sequence(:email, 100) { |n| "demo-#{n}@lmkw.io" }
    password { "super-secure" }
    password_confirmation { "super-secure" }
  end
end
