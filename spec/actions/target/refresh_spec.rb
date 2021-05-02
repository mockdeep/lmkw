# frozen_string_literal: true

require "rails_helper"

RSpec.describe Target::Refresh do
  it "does nothing when next_refresh_at is in future" do
    target = create(:target, value: 2, delta: 1)

    expect { described_class.call(target) }
      .to not_change_record(target, :next_refresh_at)
      .and not_change_record(target, :value)
  end

  it "does not change value when it already matches goal" do
    target = create(:target, :refreshable)

    expect { described_class.call(target) }.not_to change_record(target, :value)
  end

  it "updates next_refresh_at" do
    target = create(:target, :refreshable)

    expect { described_class.call(target) }
      .to change_record(target, :next_refresh_at).to(Time.zone.tomorrow)
  end

  it "subtracts the delta from the value" do
    target = create(:target, :refreshable, value: 50, delta: 6)

    expect { described_class.call(target) }
      .to change_record(target, :value).to(44)
  end

  it "sets the value to goal_value when difference is less than delta" do
    target = create(:target, :refreshable, value: 50, goal_value: 48, delta: 6)

    expect { described_class.call(target) }
      .to change_record(target, :value).to(48)
  end

  it "does not decrement target until check is active" do
    target = create(:target, :refreshable, value: 5, delta: 1)
    count = create(:count, check: target.check, value: 3)
    target.check.update!(latest_count: count)

    expect { described_class.call(target) }
      .to change_record(target, :value).from(5).to(4)
  end

  context "when force is true" do
    it "updates the value when next_refresh_at is in future" do
      target = create(:target, value: 2, delta: 1)

      expect { described_class.call(target, force: true) }
        .to change_record(target, :value).from(2).to(1)
    end

    it "decrements target until check is active" do
      target = create(:target, value: 5, delta: 1)
      count = create(:count, check: target.check, value: 3)
      target.check.update!(latest_count: count)

      expect { described_class.call(target, force: true) }
        .to change_record(target, :value).from(5).to(2)
    end
  end
end
