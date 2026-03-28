# frozen_string_literal: true

class Trello::Checklist
  attr_accessor :id, :name, :check_items, :pos

  def initialize(id:, name:, check_items: [], pos: 0)
    self.id = id
    self.name = name
    self.pos = pos
    self.check_items =
      check_items.map do |item|
        ChecklistItem.new(**item.slice(:id, :name, :state, :pos))
      end
  end

  def items
    check_items.sort_by(&:pos)
  end

  def incomplete_items
    items.reject(&:complete?)
  end

  class ChecklistItem
    attr_accessor :id, :name, :state, :pos

    def initialize(id:, name:, state:, pos: 0)
      self.id = id
      self.name = name
      self.state = state
      self.pos = pos
    end

    def complete?
      state == "complete"
    end
  end
end
