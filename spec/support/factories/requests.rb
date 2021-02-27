# frozen_string_literal: true

module Factories
  def make_request(session: {}, headers: {})
    request = ActionDispatch::Request.new(headers)
    request.session = session
    request
  end
end
