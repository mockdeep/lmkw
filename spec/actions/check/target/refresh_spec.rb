# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Target::Refresh do
  it "does nothing when next_refresh_at is in future" do
    target = create_target(next_refresh_at: 2.days.from_now.beginning_of_day)

    expect { described_class.call(target) }
      .to not_change_record(target, :next_refresh_at)
      .and not_change_record(target, :value)
  end

  it "does not change value when it already matches goal" do
    target = create_target(:refreshable)

    expect { described_class.call(target) }.not_to change_record(target, :value)
  end

  it "updates next_refresh_at" do
    target = create_target(:refreshable)

    expect { described_class.call(target) }
      .to change_record(target, :next_refresh_at).to(Time.zone.tomorrow)
  end

  it "subtracts the delta from the value" do
    target = create_target(next_refresh_at: 1.day.ago, value: 50, delta: 6)

    expect { described_class.call(target) }
      .to change_record(target, :value).to(44)
  end

  it "sets the value to goal_value when difference is less than delta" do
    target = create_target(:refreshable, value: 50, goal_value: 48, delta: 6)

    expect { described_class.call(target) }
      .to change_record(target, :value).to(48)
  end
end
