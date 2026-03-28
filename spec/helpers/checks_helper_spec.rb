# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChecksHelper do
  def checklist_item_objects(check)
    card = instance_double(Trello::Card, id: "c")
    item = instance_double(Trello::Checklist::ChecklistItem, id: "i")
    [check, card, item]
  end

  describe "#checklist_item_data" do
    def check
      @check ||= create(:check)
    end

    def result
      @result ||= helper.checklist_item_data(*checklist_item_objects(check))
    end

    it "includes the correct controller and action" do
      expect(result).to include(
        controller: "checklist-item",
        action: "change->checklist-item#toggle",
      )
    end

    it "includes the correct item values" do
      expect(result).to include(
        checklist_item_card_id_value: "c",
        checklist_item_item_id_value: "i",
        checklist_item_url_value: update_checklist_item_check_path(check),
      )
    end
  end

  describe "#linkify_text" do
    it "replaces URLs with links" do
      result = helper.linkify_text("Visit https://example.com today")
      expect(result).to include("href=\"https://example.com\"")
    end

    context "with ampersands in URL" do
      def result
        @result ||= helper.linkify_text("See https://example.com?a=1&b=2 here")
      end

      it "encodes ampersands correctly" do
        expect(result).to include("href=\"https://example.com?a=1&amp;b=2\"")
      end

      it "does not double-escape ampersands" do
        expect(result).not_to include("&amp;amp;")
      end
    end

    context "with HTML in text" do
      def result
        @result ||= helper.linkify_text("<script>alert(1)</script>")
      end

      it "escapes HTML tags" do
        expect(result).to include("&lt;script&gt;")
      end

      it "does not include raw HTML" do
        expect(result).not_to include("<script>")
      end
    end
  end
end
