# frozen_string_literal: true

require "rails_helper"

RSpec.describe "check_counts/new", type: :system, js: true do
  def user_creates_check_count
    click_link("visit manual")

    fill_in(:Value, with: 10)

    click_button("Update Count")
  end

  def create_check
    integration = create(:manual_integration)
    Check::Manual::AnyCount.create!(
      name: "Dishes in sink",
      integration: integration,
      user: integration.user,
      target_attributes: {},
    )
  end

  it "allows creating new check counts" do
    check = create_check
    sign_in(check.user)
    expect(page).to have_inactive_check(check.name)

    user_creates_check_count

    expect(page).to have_active_check(check.name)
  end
end
