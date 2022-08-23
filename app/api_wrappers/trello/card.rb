# frozen_string_literal: true

class Trello::Card
  attr_accessor :id, :name

  def initialize(id:, name:)
    self.id = id
    self.name = name
  end
end
