# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check, type: :model do
  it { is_expected.to belong_to(:integration) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:counts).class_name('CheckCount') }
  it { is_expected.to validate_presence_of(:user_id) }

  describe "#refresh" do
    it "raises a NotImplementedError" do
      expect { described_class.new.refresh }
        .to raise_error(NotImplementedError)
    end
  end
end
