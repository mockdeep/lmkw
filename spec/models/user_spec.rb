# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:integrations).dependent(:delete_all) }
  it { is_expected.to have_many(:checks).dependent(:delete_all) }
  it { is_expected.to have_many(:targets).through(:checks) }
  it { is_expected.to have_many(:api_keys).dependent(:delete_all) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to have_secure_password }

  it "allows good emails" do
    good_emails = [
      "b@b.com", "mrspicy+extra@yepyep.com", "you.are@atthe.museum"
    ]

    expect(described_class.new).to allow_values(*good_emails).for(:email)
  end

  it "does not allow bad emails" do
    bad_emails = [
      "b#b.com", "mrspicy>extra@yepyep.com", "blahbloo"
    ]

    expect(described_class.new).not_to allow_values(bad_emails).for(:email)
  end

  describe "#logged_in?" do
    it "returns true" do
      expect(described_class.new.logged_in?).to be(true)
    end
  end

  describe "#admin?" do
    it "returns false" do
      expect(described_class.new.admin?).to be(false)
    end
  end
end
