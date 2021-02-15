# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Target, type: :model do
  it { is_expected.to belong_to(:check) }
  it { is_expected.to validate_presence_of(:check) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:delta) }
  it { is_expected.to validate_presence_of(:goal_value) }
  it { is_expected.to validate_presence_of(:next_refresh_at) }

  it do
    create_check

    expect(described_class.new).to validate_uniqueness_of(:check_id)
  end
end
