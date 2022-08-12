# frozen_string_literal: true

class Integration::Trello < Integration
  validates :member_token, presence: true
  store_accessor :data, :member_token
  delegate :implementation, to: :class

  class_attribute :implementation, default: ::Trello
  class_attribute :client_class, default: NTrello::Client

  def self.authorize_url(return_url:)
    client_class.authorize_url(return_url:)
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
    @client ||= client_class.new(member_token:)
  end

  def open_boards_path
    "/members/#{trello_member.username}/boards?filter=open"
  end

  def trello_member
    client.find(:member, :me)
  end
end
