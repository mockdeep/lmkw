# frozen_string_literal: true

module NTrello::Client
  def self.developer_public_key
    Rails.configuration.x.trello.developer_public_key
  end

  def self.authorize_url(return_url:)
    ::Trello.authorize_url(
      key: developer_public_key,
      name: "LetMeKnowWhen",
      scope: "read",
      callback_method: "fragment",
      return_url:,
      response_type: "fragment",
    ).to_s
  end
end
