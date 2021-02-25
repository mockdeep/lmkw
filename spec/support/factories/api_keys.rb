# frozen_string_literal: true

module Factories
  def create_api_key(**params)
    build_api_key(**params).tap(&:save!)
  end

  def build_api_key(user: create_user, name: "Test App", **params)
    ApiKey.create!(user: user, name: name, **params)
  end

  def api_key_headers(api_key, user_id: api_key.user_id, value: api_key.value)
    hash = { "HTTP_X_USER_ID" => user_id, "HTTP_X_API_KEY" => value }
    ActionDispatch::Http::Headers.from_hash(hash)
  end
end
