# frozen_string_literal: true

FactoryBot.define do
  factory(:integration, class: "Test::Integration") do
    user { default_user }
  end
end
