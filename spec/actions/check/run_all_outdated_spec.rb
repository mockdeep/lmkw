# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::RunAllOutdated do
  include ActiveJob::TestHelper

  around do |example|
    adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    perform_enqueued_jobs { example.run }
    ActiveJob::Base.queue_adapter = adapter
  end

  it "runs checks that have not been updated in the last five minutes" do
    count = create(:count, created_at: 6.minutes.ago)
    check = count.check
    Test::Check.next_values << 5

    expect { described_class.call }.to change(check.counts, :count).by(1)
  end

  it "does not run checks that have been updated in the last five minutes" do
    count = create(:count, created_at: 4.minutes.ago)
    check = count.check

    expect { described_class.call }.not_to change(check.counts, :count)
  end
end
