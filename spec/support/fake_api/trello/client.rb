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

    Trello::Board.new(id: board.id, name: board.name, url: board.url)
  end

  def fetch_lists(**)
    lists = FakeApi::Trello::Implementation::List.all

    lists.map { |list| Trello::List.new(id: list.id, name: list.name) }
  end

  def fetch_cards(**)
    [fake_card("card1", "Test Card 1"), fake_card("card2", "Test Card 2")]
  end

  def fake_card(id, name)
    Trello::Card.new(id:, name:, short_url: "https://trello.com/c/#{id}")
  end

  def update_checklist_item(**); end

  def fetch_boards
    FakeApi::Trello::Implementation::Board.all
  end

  def get(url); end
end
