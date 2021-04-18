# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::SessionFind do
  it "returns the user when found" do
    user = create(:user)

    expect(described_class.call(user_id: user.id)).to eq(user)
  end

  it "clears the session and raises an error when user is not found" do
    session = { user_id: "not an id" }
    expect { described_class.call(session) }
      .to invoke(:clear)
      .on(session)
      .and raise_error(ActiveRecord::RecordNotFound)
  end
end
