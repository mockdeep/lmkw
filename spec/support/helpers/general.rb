# frozen_string_literal: true

module Helpers::General
  def make_request(session: {}, headers: {})
    request = ActionDispatch::Request.new(headers)
    request.session = session
    request
  end

  def api_key_headers(api_key, user_id: api_key.user_id, value: api_key.value)
    hash = { "HTTP_X_USER_ID" => user_id, "HTTP_X_API_KEY" => value }
    ActionDispatch::Http::Headers.from_hash(hash)
  end
end
