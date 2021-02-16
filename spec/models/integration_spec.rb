# frozen_string_literal: true

require "rails_helper"

RSpec.describe Integration, type: :model do
  it { is_expected.to have_many(:checks).dependent(:delete_all) }

  describe ".github" do
    it "returns GitHub integrations" do
      integration = create_github_integration

      expect(described_class.github).to eq([integration])
    end

    it "does not return other integrations" do
      create_trello_integration

      expect(described_class.github).to eq([])
    end
  end

  describe ".trello" do
    it "returns Trello integrations" do
      integration = create_trello_integration

      expect(described_class.trello).to eq([integration])
    end

    it "does not return other integrations" do
      create_github_integration

      expect(described_class.trello).to eq([])
    end
  end

  describe ".manual" do
    it "returns manual integrations" do
      integration = create_manual_integration

      expect(described_class.manual).to eq([integration])
    end

    it "does not return other integrations" do
      create_github_integration

      expect(described_class.manual).to eq([])
    end
  end
end
