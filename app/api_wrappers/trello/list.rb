# frozen_string_literal: true

class Trello::List
  attr_accessor :id, :name

  def initialize(id:, name:)
    self.id = id
    self.name = name
  end
end
