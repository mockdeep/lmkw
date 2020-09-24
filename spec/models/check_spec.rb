# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check, type: :model do
  it { is_expected.to belong_to(:integration) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:counts).class_name("CheckCount") }
  it { is_expected.to validate_presence_of(:user_id) }

  def create_check(counts: [])
    integration = create_integration
    check = Test::Check.create!(
      name: "some check",
      integration: integration,
      user: integration.user,
    )
    counts.each do |count_params|
      create_count(count_params.merge(check: check))
    end
    check
  end

  def create_count(params)
    CheckCount.create!({ value: 0 }.merge(params))
  end

  def create_integration
    Test::Integration.create!(user: create_user)
  end

  def create_user
    User.create!(
      email: "demo@exampoo.com",
      password: "super-secure",
      password_confirmation: "super-secure",
    )
  end

  describe ".last_counted_before" do
    it "returns checks with counts prior to timestamp" do
      check = create_check(
        counts: [{ created_at: 1.day.ago }],
      )

      expect(described_class.last_counted_before(1.minute.ago)).to eq([check])
    end

    it "does not return checks with counts after the timestamp" do
      create_check(
        counts: [{ created_at: 5.minutes.ago }],
      )

      expect(described_class.last_counted_before(1.hour.ago)).to eq([])
    end

    it "does not return checks with no counts" do
      create_check

      expect(described_class.last_counted_before(Time.zone.now)).to eq([])
    end
  end

  describe "#refresh" do
    it "raises a NotImplementedError" do
      expect { described_class.new.refresh }
        .to raise_error(NotImplementedError)
    end
  end

end
