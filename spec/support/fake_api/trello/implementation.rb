# frozen_string_literal: true

require_relative "../modules"

class FakeApi::Trello::Implementation
  class Board
    def self.from_response(_response)
      all
    end

    def self.all
      @all ||= [new(id: "dev-board", name: "Dev Board")]
    end

    def self.find(id)
      all.find { |board| board.id == id }
    end

    attr_accessor :id, :name

    def initialize(id:, name:)
      self.id = id
      self.name = name
    end

    def lists
      List.all
    end

    def url
      "/who_cares"
    end
  end

  class List
    def self.all
      @all ||= [new(id: "inbox", name: "Inbox")]
    end

    def self.find(id)
      all.find { |list| list.id == id }
    end

    attr_accessor :id, :name

    def initialize(id:, name:)
      self.id = id
      self.name = name
    end

    # def cards
    #   [1, 2, 3]
    # end
  end

  class Card
    attr_accessor :id, :name
  end

  class Member
    def username
      "fake_user"
    end
  end

  class Client
    attr_accessor :member_token, :developer_public_key

    def initialize(member_token:, developer_public_key:)
      self.member_token = member_token
      self.developer_public_key = developer_public_key
    end

    def get(url); end

    def find_many(klass, _path)
      case klass.name
      when "Trello::Card"
        [Card.new, Card.new, Card.new]
      when "Trello::List"
        List.all
      else
        raise ArgumentError, "unknown klass \"#{klass}\""
      end
    end

    def find(entity, id)
      case entity
      when :member
        Member.new
      when :board
        Board.find(id)
      when :list
        List.find(id)
      else
        raise ArgumentError, "unknown entity \"#{entity}\""
      end
    end
  end
end
