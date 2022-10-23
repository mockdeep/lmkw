# frozen_string_literal: true

class Trello::Client
  attr_accessor :member_token

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

  def fetch_board(id:)
    response = HTTP.get(board_url(id:))
    board = JSON.parse(response.body, symbolize_names: true)

    Trello::Board.new(**board.slice(:id, :name, :url))
  end

  def fetch_lists(board_id:)
    response = HTTP.get(lists_url(board_id:))
    lists = JSON.parse(response.body, symbolize_names: true)

    lists.map { |list| Trello::List.new(**list.slice(:id, :name)) }
  end

  def fetch_cards(list_id:)
    response = HTTP.get(cards_url(list_id:))
    cards = JSON.parse(response.body, symbolize_names: true)

    cards.map { |card| Trello::Card.new(**card.slice(:id, :name)) }
  end

  def fetch_boards
    response = HTTP.get(open_boards_url)
    boards = JSON.parse(response.body, symbolize_names: true)

    boards.map { |board| Trello::Board.new(**board.slice(:id, :name, :url)) }
  end

  private

  def developer_public_key
    self.class.developer_public_key
  end

  def board_url(id:)
    trello_api_url("boards/#{id}")
  end

  def lists_url(board_id:)
    trello_api_url("boards/#{board_id}/lists")
  end

  def cards_url(list_id:)
    trello_api_url("lists/#{list_id}/cards")
  end

  def open_boards_url
    trello_api_url("members/#{username}/boards", filter: "open")
  end

  def trello_api_url(path, **params)
    params.merge!(auth_params)

    "https://api.trello.com/1/#{path}?#{params.to_query}"
  end

  def auth_params
    { key: developer_public_key, token: member_token }
  end

  def username
    response = HTTP.get(trello_member_url)
    data = JSON.parse(response.body, symbolize_names: true)
    data[:username]
  end

  def trello_member_url
    trello_api_url("members/me")
  end
end
