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
