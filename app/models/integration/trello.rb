# frozen_string_literal: true

class Integration::Trello < Integration
  validates :member_token, presence: true
  store_accessor :data, :member_token
  delegate :fetch_boards, to: :client

  class_attribute :client_class, default: NTrello::Client

  def self.authorize_url(return_url:)
    client_class.authorize_url(return_url:)
  end

  def fetch_board(id:)
    board = client.find(:board, id)

    NTrello::Board.new(id: board.id, url: board.url)
  end

  def fetch_lists(board_id:)
    lists = client.find_many(::Trello::List, "/boards/#{board_id}/lists")

    lists.map { |list| NTrello::List.new(id: list.id, name: list.name) }
  end

  def fetch_cards(list_id:)
    cards = client.find_many(::Trello::Card, "/lists/#{list_id}/cards")

    cards.map { |card| NTrello::Card.new(id: card.id, name: card.name) }
  end

  private

  def client
    @client ||= client_class.new(member_token:)
  end
end
