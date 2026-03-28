# frozen_string_literal: true

require "rails_helper"

RSpec.describe Integration::Trello do
  def fake_implementation
    require Rails.root.join("spec/support/fake_api/trello/client")
    existing_class = described_class.client_class
    described_class.client_class = FakeApi::Trello::Client
    yield
    described_class.client_class = existing_class
  end

  def update_args
    { card_id: "c1", item_id: "i1", state: "complete" }
  end

  def client_spy_for(klass)
    spy = instance_spy(klass)
    expect(klass).to receive(:new).and_return(spy)
    spy
  end

  describe "#update_checklist_item" do
    it "delegates to the client with correct arguments" do
      fake_implementation do
        client = client_spy_for(FakeApi::Trello::Client)
        expect(client).to receive(:update_checklist_item).with(**update_args)
        create(:trello_integration).update_checklist_item(**update_args)
      end
    end
  end
end
