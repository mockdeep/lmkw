# frozen_string_literal: true

class Check::Trello::ListHasCards < Check
  store_accessor :data, :board_id, :list_id
  validates :board_id, :list_id, presence: true
  delegate :fetch_boards, to: :integration
  delegate :url, to: :board

  STEPS = ["board_id", "list_id", "name"].freeze

  def service
    "Trello"
  end

  def icon
    ["fab", "trello"]
  end

  def next_count
    cards.count
  end

  def next_step
    STEPS.find { |step| public_send(step).nil? }
  end

  def board
    integration.fetch_board(id: board_id)
  end

  def cards
    integration.fetch_cards(list_id:)
  end

  def lists
    integration.fetch_lists(board_id:)
  end
end
