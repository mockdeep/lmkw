# frozen_string_literal: true

require "rails_helper"

RSpec.describe Target::RefreshOne do
  it "refreshes a single target for the given user" do
    targets = create_pair(:target, :unreached_goal)

    expect { described_class.call(default_user) }
      .to change_record(targets.first, :value).from(5).to(4)
      .and not_change_record(targets.second, :value).from(5)
  end

  it "refreshes the target with the nearest next_refresh_at" do
    target1 = create(:target, :unreached_goal, next_refresh_at: 2.days.from_now)
    target2 = create(:target, :unreached_goal, next_refresh_at: 1.day.from_now)

    expect { described_class.call(default_user) }
      .to change_record(target2, :value).from(5).to(4)
      .and not_change_record(target1, :value).from(5)
  end

  it "does nothing when the user has no unreached goal targets" do
    target = create(:target, check_value: 5, goal_value: 5, value: 5, delta: 1)

    expect { described_class.call(default_user) }
      .to not_change_record(target, :value).from(5)
  end
end
