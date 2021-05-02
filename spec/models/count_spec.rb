# frozen_string_literal: true

require "rails_helper"

RSpec.describe Count, type: :model do
  it { is_expected.to validate_presence_of(:check_id) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to belong_to(:check) }
end
