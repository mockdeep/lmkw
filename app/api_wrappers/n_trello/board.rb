# frozen_string_literal: true

class NTrello::Board
  attr_accessor :id, :url

  def initialize(id:, url:)
    self.id = id
    self.url = url
  end
end
