# frozen_string_literal: true

class Check < ApplicationRecord
  module Trello
    class ListHasCards < Check
      store_accessor :data, :board_id, :list_id, :list_name
      validates :board_id, :list_id, presence: true
      delegate :boards, to: :integration
      delegate :lists, :url, to: :board
      delegate :cards, to: :list

      STEPS = ["board_id", "list_id", "name"].freeze

      def refresh
        counts.create!(value: cards.count)
      end

      def next_step
        STEPS.find { |step| public_send(step).nil? }
      end

      def message
        "#{last_value} cards in #{list.name}"
      end

      def board
        integration.find_board(board_id)
      end

      def list
        integration.find_list(list_id)
      end
    end
  end
end
