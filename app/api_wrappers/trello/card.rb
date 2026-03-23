# frozen_string_literal: true

class Trello::Card
  attr_accessor :id, :name, :short_url, :checklists

  def initialize(id:, name:, short_url: nil, checklists: nil)
    self.id = id
    self.name = name
    self.short_url = short_url || "https://trello.com/c/#{id}"
    self.checklists = checklists || []
  end

  def url
    short_url
  end
end
