# frozen_string_literal: true

class NTrello::Client
  attr_accessor :member_token

  delegate :find, :find_many, :get, to: :trello_client

  def self.developer_public_key
    Rails.configuration.x.trello.developer_public_key
  end

  def self.authorize_url(return_url:)
    params = {
      callback_method: "fragment",
      expiration: "never",
      key: developer_public_key,
      name: "LetMeKnowWhen",
      response_type: "fragment",
      return_url:,
      scope: "read",
    }

    "https://trello.com/1/authorize?#{params.to_query}"
  end

  def initialize(member_token:)
    self.member_token = member_token
  end

  def fetch_boards
    response = HTTP.get(open_boards_url)

    ::Trello::Board.from_response(response.body.to_s)
  end

  private

  def developer_public_key
    self.class.developer_public_key
  end

  def trello_client
    @trello_client ||=
      ::Trello::Client.new(member_token:, developer_public_key:)
  end

  def open_boards_url
    params = { filter: "open", **auth_params }

    "https://api.trello.com/1/members/#{username}/boards?#{params.to_query}"
  end

  def auth_params
    { key: developer_public_key, token: member_token }
  end

  def username
    response = HTTP.get(trello_member_url)
    data = JSON.parse(response.body).deep_symbolize_keys
    data[:username]
  end

  def trello_member_url
    "https://api.trello.com/1/members/me?#{auth_params.to_query}"
  end
end
