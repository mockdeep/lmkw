# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::RequestFind do
  it "finds the user by session when user_id is present" do
    user = create(:user)
    request = make_request(session: { user_id: user.id })

    expect(described_class.call(request)).to eq(user)
  end

  it "finds the user by api key when present" do
    api_key = create(:api_key)
    headers = api_key_headers(api_key)
    request = make_request(headers:)

    expect(described_class.call(request)).to eq(api_key.user)
  end

  it "returns a NullUser when no session[:user_id]" do
    request = make_request

    expect(described_class.call(request)).to be_a(NullUser)
  end
end
