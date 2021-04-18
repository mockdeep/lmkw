# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::ApiKeyFind do
  it "returns a user when one of their API keys match" do
    api_key = create_api_key
    headers = api_key_headers(api_key)

    expect(described_class.call(headers)).to eq(api_key.user)
  end

  it "raises an error when no user API keys match" do
    api_key = create_api_key
    headers = api_key_headers(api_key, value: "foo")

    expect { described_class.call(headers) }
      .to raise_error(ActiveRecord::RecordNotFound)
  end

  it "raises an error when given a different user" do
    api_key = create_api_key
    headers = api_key_headers(api_key, user_id: create(:user).id)

    expect { described_class.call(headers) }
      .to raise_error(ActiveRecord::RecordNotFound)
  end
end
