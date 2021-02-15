# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Refresh do
  it "creates the next count" do
    check = create_check
    Test::Check.next_values << 21

    described_class.call(check)

    expect(check.last_value).to eq(21)
  end

  it "refreshes its target" do
    check = create_check
    Test::Check.next_values << 21

    expect { described_class.call(check) }
      .to invoke(:call).on(Check::Target::Refresh).with(check.target)
  end
end
