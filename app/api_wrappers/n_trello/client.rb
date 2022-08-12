# frozen_string_literal: true

class NTrello::Client
  attr_accessor :member_token

  delegate :find, :find_many, :get, to: :trello_client

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

  def initialize(member_token:)
    self.member_token = member_token
  end

  private

  def developer_public_key
    self.class.developer_public_key
  end

  def trello_client
    @trello_client ||=
      ::Trello::Client.new(member_token:, developer_public_key:)
  end
end
