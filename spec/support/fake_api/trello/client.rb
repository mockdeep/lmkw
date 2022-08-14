# frozen_string_literal: true

class FakeApi::Trello::Client
  attr_accessor :member_token

  def self.authorize_url(return_url:, **_args)
    "/trello/tokens/new?returnUrl=#{return_url}"
  end

  def initialize(member_token:)
    self.member_token = member_token
  end

  def find(entity, id)
    case entity
    when :member
      FakeApi::Trello::Implementation::Member.new
    when :board
      FakeApi::Trello::Implementation::Board.find(id)
    when :list
      FakeApi::Trello::Implementation::List.find(id)
    else
      raise ArgumentError, "unknown entity \"#{entity}\""
    end
  end

  def fetch_board(id:)
    board = find(:board, id)

    NTrello::Board.new(id: board.id, url: board.url)
  end

  def fetch_lists(board_id:)
    lists = find_many(::Trello::List, "/boards/#{board_id}/lists")

    lists.map { |list| NTrello::List.new(id: list.id, name: list.name) }
  end

  def fetch_cards(list_id:)
    cards = find_many(::Trello::Card, "/lists/#{list_id}/cards")

    cards.map { |card| NTrello::Card.new(id: card.id, name: card.name) }
  end

  def find_many(klass, _path)
    case klass.name
    when "Trello::Card"
      card = NTrello::Card.new(id: 1, name: "some card")
      [card, card, card]
    when "Trello::List"
      FakeApi::Trello::Implementation::List.all
    else
      raise ArgumentError, "unknown klass \"#{klass}\""
    end
  end

  def fetch_boards
    FakeApi::Trello::Implementation::Board.all
  end

  def get(url); end
end
