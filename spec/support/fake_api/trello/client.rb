# frozen_string_literal: true

module FakeApi::Trello::Client
  def self.authorize_url(return_url:, **_args)
    "/trello/tokens/new?returnUrl=#{return_url}"
  end
end
