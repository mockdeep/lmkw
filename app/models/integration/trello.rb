# frozen_string_literal: true

class Integration::Trello < Integration
  validates :member_token, presence: true
  store_accessor :data, :member_token
  delegate :developer_public_key, :implementation, to: :class

  class_attribute :implementation, default: ::Trello

  def self.authorize_url(return_url:)
    implementation.authorize_url(
      key: developer_public_key,
      name: "LetMeKnowWhen",
      scope: "read",
      callback_method: "fragment",
      return_url:,
      response_type: "fragment",
    ).to_s
  end

  def self.developer_public_key
    Rails.configuration.x.trello.developer_public_key
  end

  def boards
    implementation::Board.from_response(client.get(open_boards_path))
  end

  def find_board(board_id)
    board = client.find(:board, board_id)

    NTrello::Board.new(id: board.id, url: board.url)
  end

  def find_lists(board_id)
    lists = client.find_many(::Trello::List, "/boards/#{board_id}/lists")

    lists.map { |list| NTrello::List.new(id: list.id, name: list.name) }
  end

  def find_cards(list_id)
    cards = client.find_many(::Trello::Card, "/lists/#{list_id}/cards")

    cards.map { |card| NTrello::Card.new(id: card.id, name: card.name) }
  end

  private

  def client
    @client ||= implementation::Client.new(
      member_token:,
      developer_public_key:,
    )
  end

  def open_boards_path
    "/members/#{trello_member.username}/boards?filter=open"
  end

  def trello_member
    client.find(:member, :me)
  end
end
