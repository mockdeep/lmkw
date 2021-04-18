# frozen_string_literal: true

FactoryBot.define do
  factory(:count, class: "CheckCount") do
    check
    value { 0 }
  end
end
