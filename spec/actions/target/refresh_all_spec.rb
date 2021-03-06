# frozen_string_literal: true

require "rails_helper"

RSpec.describe Target::RefreshAll do
  it "refreshes all targets for the given user" do
    targets = create_pair(:target, check_value: 3, value: 5, delta: 5)

    expect { described_class.call(default_user) }
      .to change_record(targets.first, :value).from(5).to(0)
      .and change_record(targets.second, :value).from(5).to(0)
  end
end
