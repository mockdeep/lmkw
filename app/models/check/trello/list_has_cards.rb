# frozen_string_literal: true

class Check::Trello::ListHasCards < Check
  store_accessor :data, :board_id, :list_id
  validates :board_id, :list_id, presence: true
  delegate :boards, to: :integration
  delegate :lists, :url, to: :board
  delegate :cards, to: :list

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
    integration.find_board(board_id)
  end

  def list
    integration.find_list(list_id)
  end
end
