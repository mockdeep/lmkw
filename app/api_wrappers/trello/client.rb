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
      scope: "read,write",
    }

    "https://trello.com/1/authorize?#{params.to_query}"
  end

  def initialize(member_token:)
    self.member_token = member_token
  end

  def fetch_board(id:)
    board = request_json(:get, board_url(id:))
    Trello::Board.new(**board.slice(:id, :name, :url))
  end

  def fetch_lists(board_id:)
    lists = request_json(:get, lists_url(board_id:))
    lists.map { |list| Trello::List.new(**list.slice(:id, :name)) }
  end

  def fetch_cards(list_id:)
    url = cards_url(list_id:)
    cards = request_json(:get, url, params: { checklists: "all" })
    cards.map { |card| build_card(card) }
  end

  def update_checklist_item(card_id:, item_id:, state:)
    request_json(
      :put,
      checklist_item_url(card_id:, item_id:),
      params: { key: developer_public_key, token: member_token, state: },
    )
  end

  def fetch_boards
    url = trello_api_url("members/#{username}/boards", filter: "open")
    boards = request_json(:get, url)
    boards.map { |board| Trello::Board.new(**board.slice(:id, :name, :url)) }
  end

  private

  def developer_public_key
    self.class.developer_public_key
  end

  def build_card(card)
    Trello::Card.new(
      id: card[:id],
      name: card[:name],
      short_url: card[:shortUrl],
      checklists: build_checklists(card[:checklists] || []),
    )
  end

  def build_checklists(checklists_data)
    checklists_data.map { |raw| build_checklist(raw) }.sort_by(&:pos)
  end

  def build_checklist(raw)
    Trello::Checklist.new(
      id: raw[:id],
      name: raw[:name],
      check_items: raw[:checkItems] || [],
      pos: raw[:pos],
    )
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

  def trello_api_url(path, **params)
    params.merge!(auth_params)

    "https://api.trello.com/1/#{path}?#{params.to_query}"
  end

  def auth_params
    { key: developer_public_key, token: member_token }
  end

  def username
    request_json(:get, trello_api_url("members/me"))[:username]
  end

  def checklist_item_url(card_id:, item_id:)
    "https://api.trello.com/1/cards/#{card_id}/checkItem/#{item_id}"
  end

  def request_json(method, url, **)
    response = HTTP.timeout(connect: 5, read: 10).public_send(method, url, **)
    unless response.status.success?
      raise Trello::ApiError, "Trello API error #{response.status.code}"
    end

    JSON.parse(response.body, symbolize_names: true)
  rescue HTTP::Error, JSON::ParserError => e
    raise Trello::ApiError, "Trello request failed: #{e.message}"
  end
end
