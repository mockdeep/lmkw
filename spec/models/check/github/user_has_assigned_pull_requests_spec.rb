# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Github::UserHasAssignedPullRequests do
  def fake_implementation
    existing_implementation = Integration::Github.implementation
    Integration::Github.implementation = FakeApi::Github::Implementation

    yield

    Integration::Github.implementation = existing_implementation
  end

  describe "#next_count" do
    it "returns the count of pull requests" do
      fake_implementation do
        integration = create(:github_integration)
        check = described_class.new(integration: integration)

        expect(check.next_count).to eq(2)
      end
    end
  end

  describe "#icon" do
    it "returns an array for the icon" do
      expect(described_class.new.icon).to eq(["fab", "github"])
    end
  end
end
