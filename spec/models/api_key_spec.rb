# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiKey, type: :model do
  it { is_expected.to have_secure_token(:value) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:user_id) }

  describe "#==" do
    context "when other is a string" do
      it "returns true when value matches string" do
        api_key = described_class.new(value: "foo")

        expect(api_key == "foo").to be(true)
      end

      it "returns false when value does not match string" do
        api_key = described_class.new(value: "foo")

        expect(api_key == "bar").to be(false)
      end
    end

    context "when other is not a string" do
      it "returns true when given the same record" do
        api_key = create(:api_key)

        expect(api_key == described_class.find(api_key.id)).to be(true)
      end

      it "returns false when given another record" do
        api_key1 = create(:api_key)
        api_key2 = create(:api_key)

        expect(api_key1 == api_key2).to be(false)
      end

      it "returns false when given another type of object" do
        api_key = create(:api_key)

        expect(api_key == api_key.user).to be(false)
      end
    end
  end
end
