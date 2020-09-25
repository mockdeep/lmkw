# frozen_string_literal: true

require "rails_helper"

RSpec.describe Check, type: :model do
  describe "#refresh" do
    it "raises a NotImplementedError" do
      expect { described_class.new.refresh }
        .to raise_error(NotImplementedError)
    end
  end
end
