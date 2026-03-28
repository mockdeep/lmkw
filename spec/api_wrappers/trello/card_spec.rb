# frozen_string_literal: true

require "rails_helper"

RSpec.describe Trello::Card do
  describe "#url" do
    it "returns the short_url" do
      card = described_class.new(id: "1", name: "n", short_url: "https://trello.com/c/1")
      expect(card.url).to eq("https://trello.com/c/1")
    end
  end
end
