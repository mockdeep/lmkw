# frozen_string_literal: true

module Factories
  def create_api_key(**params)
    build_api_key(**params).tap(&:save!)
  end

  def build_api_key(user: create(:user), name: "Test App", **params)
    ApiKey.create!(user: user, name: name, **params)
  end
end
