# frozen_string_literal: true

class Trello::Board
  attr_accessor :id, :name, :url

  def initialize(id:, name:, url:)
    self.id = id
    self.name = name
    self.url = url
  end
end
