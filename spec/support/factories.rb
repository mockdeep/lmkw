# frozen_string_literal: true

module Factories
  def create_check(counts: [])
    integration = create_integration
    check = Test::Check.create!(
      name: "some check",
      integration: integration,
      user: integration.user,
    )
    counts.each do |count_params|
      create_count(count_params.merge(check: check))
    end
    check
  end

  def create_count(params)
    CheckCount.create!({ value: 0 }.merge(params))
  end

  def create_integration
    Test::Integration.create!(user: create_user)
  end

  def create_user
    User.create!(
      email: "demo@exampoo.com",
      password: "super-secure",
      password_confirmation: "super-secure",
    )
  end
end

RSpec.configure do |config|
  config.include(Factories)
end
