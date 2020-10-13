# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::RunAllOutdated do
  it "runs checks that have not been updated in an hour" do
    check = create_check(counts: [{ created_at: 61.minutes.ago }])

    expect { described_class.call }
      .to change(check.counts, :count).by(1)
  end

  it "does not run checks that have been updated in the last hour" do
    check = create_check(counts: [{ created_at: 59.minutes.ago }])

    expect { described_class.call }
      .not_to change(check.counts, :count)
  end
end
