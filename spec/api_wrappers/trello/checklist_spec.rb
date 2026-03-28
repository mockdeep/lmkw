# frozen_string_literal: true

require "rails_helper"

RSpec.describe Trello::Checklist do
  def item_attrs(name: "task", state: "incomplete", pos: 0)
    { id: "i1", name:, state:, pos: }
  end

  def checklist_with_items(items)
    described_class.new(id: "cl1", name: "Todo", check_items: items)
  end

  describe "#initialize" do
    it "maps check_items to ChecklistItems" do
      checklist = checklist_with_items([item_attrs])
      item = checklist.check_items.first
      expect(item).to be_a(described_class::ChecklistItem)
    end
  end

  describe "#items" do
    it "returns check_items sorted by pos" do
      item_a = item_attrs(name: "A", pos: 1)
      item_b = item_attrs(name: "B", pos: 2)
      checklist = checklist_with_items([item_b, item_a])
      expect(checklist.items.map(&:name)).to eq(["A", "B"])
    end
  end

  describe "#incomplete_items" do
    it "returns only incomplete items" do
      items = [item_attrs(state: "complete"), item_attrs(state: "incomplete")]
      checklist = checklist_with_items(items)
      expect(checklist.incomplete_items.count).to eq(1)
    end
  end

  describe described_class::ChecklistItem do
    describe "#complete?" do
      it "returns true when state is complete" do
        item = described_class.new(id: "1", name: "t", state: "complete")
        expect(item).to be_complete
      end

      it "returns false when state is not complete" do
        item = described_class.new(id: "1", name: "t", state: "incomplete")
        expect(item).not_to be_complete
      end
    end
  end
end
