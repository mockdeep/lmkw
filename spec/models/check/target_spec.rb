# frozen_string_literal: true

require "rails_helper"

RSpec.describe Target do
  it { is_expected.to belong_to(:check) }

  it { is_expected.to validate_presence_of(:check) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:delta) }
  it { is_expected.to validate_presence_of(:goal_value) }
  it { is_expected.to validate_presence_of(:next_refresh_at) }

  it { is_expected.to delegate_method(:user).to(:check) }
  it { is_expected.to delegate_method(:name).to(:check).with_prefix(true) }

  it do
    create(:check)

    expect(described_class.new).to validate_uniqueness_of(:check_id)
  end

  describe ".unreached_goal" do
    it "returns targets where goal_value != value" do
      target1 = create(:target, value: 5, goal_value: 0)
      target2 = create(:target, value: 0, goal_value: 5)
      expected_targets = [target1, target2]

      expect(described_class.unreached_goal).to match_array(expected_targets)
    end

    it "does not return targets where goal_value == value" do
      create(:target, value: 5, goal_value: 5)
      create(:target, value: 0, goal_value: 0)

      expect(described_class.unreached_goal).to be_empty
    end
  end
end
