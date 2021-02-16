# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check, type: :model do
  it { is_expected.to belong_to(:integration) }
  it { is_expected.to belong_to(:user) }

  it {
    is_expected
      .to have_one(:target).class_name("Check::Target").dependent(:delete)
  }

  it {
    is_expected
      .to have_many(:counts).class_name("CheckCount").dependent(:delete_all)
  }

  it { is_expected.to validate_presence_of(:integration_id) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:target) }

  describe ".last_counted_before" do
    it "returns checks with counts prior to timestamp" do
      check = create_check(counts: [{ created_at: 1.day.ago }])

      expect(described_class.last_counted_before(1.minute.ago)).to eq([check])
    end

    it "does not return checks with counts after the timestamp" do
      create_check(
        counts: [{ created_at: 5.minutes.ago }, { created_at: 3.days.ago }],
      )

      expect(described_class.last_counted_before(1.hour.ago)).to eq([])
    end

    it "returns checks with no counts" do
      check = create_check

      expect(described_class.last_counted_before(Time.zone.now)).to eq([check])
    end
  end

  describe "#manual?" do
    it "returns false" do
      expect(described_class.new.manual?).to be(false)
    end
  end

  describe "#active?" do
    it "returns true when most recent count > 0" do
      check = create_check(counts: [{ value: 1 }])

      expect(check.active?).to be(true)
    end

    it "returns false when most recent count == 0" do
      check = create_check(counts: [{ value: 0 }])

      expect(check.active?).to be(false)
    end

    it "returns false when no counts exist" do
      check = create_check

      expect(check.active?).to be(false)
    end

    it "returns false when most recent count < target value" do
      check = create_check(counts: [{ value: 1 }], target: { value: 2 })

      expect(check.active?).to be(false)
    end

    it "returns false when most recent count == target value" do
      check = create_check(counts: [{ value: 1 }], target: { value: 1 })

      expect(check.active?).to be(false)
    end

    it "returns true when most recent count > target value" do
      check = create_check(counts: [{ value: 2 }], target: { value: 1 })

      expect(check.active?).to be(true)
    end
  end

  describe "#refresh=" do
    it "calls #refresh when given the string 'true'" do
      check = create_check

      expect { check.refresh = "true" }
        .to invoke(:call).on(Check::Refresh).with(check)
    end

    it "calls #refresh when given true" do
      check = create_check

      expect { check.refresh = true }
        .to invoke(:call).on(Check::Refresh).with(check)
    end

    it "does not call #refresh when given false" do
      check = create_check

      expect { check.refresh = false }.not_to invoke(:call).on(Check::Refresh)
    end

    it "does not call #refresh when given something truthy" do
      check = create_check

      expect { check.refresh = "troof" }.not_to invoke(:call).on(Check::Refresh)
    end
  end

  describe "#next_count" do
    it "raises a NotImplementedError" do
      expect { described_class.new.next_count }
        .to raise_error(NotImplementedError)
    end
  end
end
