# frozen_string_literal: true

class User < ApplicationRecord
  class ApiKeyFind
    include JunkDrawer::Callable

    def call(headers)
      user = User.find(headers["X-User-ID"])

      validate_api_key(user, headers["X-API-Key"])

      user
    end

    private

    def validate_api_key(user, api_key_string)
      return if api_key_matches?(user, api_key_string)

      raise ActiveRecord::RecordNotFound
    end

    def api_key_matches?(user, api_key_string)
      user.api_keys.any? { |api_key| api_key == api_key_string }
    end
  end
end
