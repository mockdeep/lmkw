# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminConstraint do
  describe "#matches?" do
    it "returns true when user is admin" do
      user = create(:user, admin: true)
      request = make_request(session: { user_id: user.id })

      expect(described_class.new.matches?(request)).to be(true)
    end

    it "returns false when no one is signed in" do
      request = make_request(session: {})

      expect(described_class.new.matches?(request)).to be(false)
    end

    it "returns false when user is not admin" do
      user = create(:user, admin: false)
      request = make_request(session: { user_id: user.id })

      expect(described_class.new.matches?(request)).to be(false)
    end

    it "raises an error when id is garbage" do
      request = make_request(session: { user_id: "garbage" })

      expect { described_class.new.matches?(request) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
