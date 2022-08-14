# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Trello::ListHasCards do
  def fake_implementation
    require Rails.root.join("spec/support/fake_api/trello/client")

    existing_client_class = Integration::Trello.client_class
    Integration::Trello.client_class = FakeApi::Trello::Client

    yield

    Integration::Trello.client_class = existing_client_class
  end

  describe "#next_count" do
    it "returns the count of cards" do
      fake_implementation do
        integration = create(:trello_integration)
        check = described_class.new(integration:, list_id: "inbox")

        expect(check.next_count).to eq(3)
      end
    end
  end

  describe "#icon" do
    it "returns an array for the icon" do
      expect(described_class.new.icon).to eq(["fab", "trello"])
    end
  end
end
