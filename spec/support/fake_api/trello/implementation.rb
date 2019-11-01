# frozen_string_literal: true

module FakeApi
  module Trello
    class Implementation
      class << self
        attr_writer :endpoint_url

        def endpoint_url
          @endpoint_url || (raise ArgumentError, "missing endpoint_url")
        end

        def authorize_url(return_url:, **_args)
          "#{endpoint_url}/1/authorize?returnUrl=#{return_url}"
        end
      end # class << self

      class Board
        class << self
          def from_response(_response)
            all
          end

          def all
            @all ||= [new(id: "dev-board", name: "Dev Board")]
          end

          def find(id)
            all.find { |board| board.id == id }
          end
        end # class << self

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
        class << self
          def all
            @all ||= [new(id: "inbox", name: "Inbox")]
          end

          def find(id)
            all.find { |list| list.id == id }
          end
        end # class << self

        attr_accessor :id, :name

        def initialize(id:, name:)
          self.id = id
          self.name = name
        end

        def cards
          [1, 2, 3]
        end
      end

      class Member
        def username
          "fake_user"
        end
      end

      class Client
        def initialize(member_token:, developer_public_key:); end

        def get(url); end

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
  end
end
