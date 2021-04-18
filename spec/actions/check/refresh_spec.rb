# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Refresh do
  it "creates the next count" do
    check = create(:check)
    Test::Check.next_values << 21

    described_class.call(check)

    expect(check.last_value).to eq(21)
  end

  it "refreshes its target" do
    check = create(:check)
    Test::Check.next_values << 21

    expect { described_class.call(check) }
      .to invoke(:call).on(Check::Target::Refresh).with(check.target)
  end

  it "does not try to create a count for manual checks" do
    check = create_manual_check

    expect { described_class.call(check) }
      .not_to change(check, :last_value).from(nil)
  end
end
