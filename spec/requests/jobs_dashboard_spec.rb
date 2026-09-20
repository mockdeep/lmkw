# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Jobs dashboard" do
  def sign_in(user)
    post(session_path, params: { session: user.slice(:email, :password) })
  end

  it "is not found for anonymous visitors" do
    get("/jobs")

    expect(response).to have_http_status(:not_found)
  end

  it "is not found for signed-in non-admins" do
    sign_in(create(:user))

    get("/jobs")

    expect(response).to have_http_status(:not_found)
  end

  it "renders for admins" do
    sign_in(create(:user, admin: true))

    get("/jobs")

    expect(response).to have_http_status(:ok)
  end
end
