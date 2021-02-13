# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check::Target, type: :model do
  it { is_expected.to belong_to(:check) }
  it { is_expected.to validate_presence_of(:check) }
  it { is_expected.to validate_presence_of(:value) }
end
