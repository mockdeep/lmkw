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

  def create_integration(type = :test, user: create_user)
    case type
    when :github
      Integration::Github.create!(user: user, access_token: "foo")
    when :trello
      Integration::Trello.create!(user: user, member_token: "foo")
    when :test
      Test::Integration.create!(user: user)
    else
      raise ArgumentError, "invalid type: #{type}"
    end
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
