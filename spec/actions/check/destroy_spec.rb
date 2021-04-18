# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Destroy do
  it "deletes the check" do
    check = create(:check)

    expect { described_class.call(check) }.to delete_record(check)
  end

  it "deletes the check when latest_count is set" do
    check = create_check(counts: [{ value: 6 }])

    expect { described_class.call(check) }.to delete_record(check)
  end

  it "deletes associated counts" do
    count = create(:count)

    expect { described_class.call(count.check) }.to delete_record(count)
  end

  it "deletes associated target" do
    target = create_target

    expect { described_class.call(target.check) }.to delete_record(target)
  end

  it "does not delete other counts" do
    count = create(:count)

    expect { described_class.call(create(:check)) }.not_to delete_record(count)
  end

  it "does not delete other targets" do
    target = create_target

    expect { described_class.call(create(:check)) }.not_to delete_record(target)
  end
end
