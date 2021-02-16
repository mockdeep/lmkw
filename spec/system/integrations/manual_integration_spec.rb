# frozen_string_literal: true

require "rails_helper"

RSpec.describe "manual integration", type: :system, js: true do
  def start_new_check
    expect(page).to have_heading("Checks")
    click_link("+ New Check")

    expect(page).to have_text("Pick an integration")
  end

  def create_manual_check(name:)
    click_link("manual")
    expect(page).to have_text("Name your check")
    fill_in("Name", with: name)
    click_button("Done")
    expect(page).to have_heading("Checks")
  end

  it "allows a user to configure a manual integration" do
    sign_in(create_user)
    start_new_check
    create_manual_check(name: "Dishes in sink")

    expect(page).to have_inactive_check("Dishes in sink")
  end
end
