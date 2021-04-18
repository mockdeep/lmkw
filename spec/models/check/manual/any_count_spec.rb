# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Manual::AnyCount, type: :model do
  include Rails.application.routes.url_helpers

  describe "#next_step" do
    it "returns 'name' when name is nil" do
      expect(described_class.new.next_step).to eq("name")
    end

    it "returns nil when 'name' is present" do
      expect(described_class.new(name: "foo").next_step).to be(nil)
    end
  end

  describe "#service" do
    it "returns 'manual'" do
      expect(described_class.new.service).to eq("manual")
    end
  end

  describe "#icon" do
    it "returns an array for the icon" do
      expect(described_class.new.icon).to eq(["fas", "exclamation"])
    end
  end

  describe "#manual?" do
    it "returns true" do
      expect(described_class.new.manual?).to be(true)
    end
  end

  describe "#url" do
    it "returns new_check_count_path" do
      check = create(:manual_check)

      expect(check.url).to eq(new_check_count_path(check))
    end
  end
end
