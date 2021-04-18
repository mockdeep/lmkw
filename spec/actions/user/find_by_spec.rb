# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::FindBy do
  it "returns the matching user" do
    user = create(:user)

    expect(described_class.call(email: user.email)).to eq(user)
  end

  it "returns a NullUser when no user is found" do
    expect(described_class.call(email: "not an email")).to be_kind_of(NullUser)
  end
end
