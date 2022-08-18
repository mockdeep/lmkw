# frozen_string_literal: true

class NTrello::Client
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
    board_url = "https://api.trello.com/1/boards/#{id}?#{auth_params.to_query}"
    response = HTTP.get(board_url)
    board = JSON.parse(response.body, symbolize_names: true)

    NTrello::Board.new(**board.slice(:id, :name, :url))
  end

  def fetch_lists(board_id:)
    lists_url =
      "https://api.trello.com/1/boards/#{board_id}/lists?#{auth_params.to_query}"
    response = HTTP.get(lists_url)
    lists = JSON.parse(response.body, symbolize_names: true)

    lists.map { |list| NTrello::List.new(**list.slice(:id, :name)) }
  end

  def fetch_cards(list_id:)
    cards_url =
      "https://api.trello.com/1/lists/#{list_id}/cards?#{auth_params.to_query}"
    response = HTTP.get(cards_url)
    cards = JSON.parse(response.body, symbolize_names: true)

    cards.map { |card| NTrello::Card.new(**card.slice(:id, :name)) }
  end

  def fetch_boards
    response = HTTP.get(open_boards_url)
    boards = JSON.parse(response.body, symbolize_names: true)

    boards.map { |board| NTrello::Board.new(**board.slice(:id, :name, :url)) }
  end

  private

  def developer_public_key
    self.class.developer_public_key
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
    data = JSON.parse(response.body, symbolize_names: true)
    data[:username]
  end

  def trello_member_url
    "https://api.trello.com/1/members/me?#{auth_params.to_query}"
  end
end
