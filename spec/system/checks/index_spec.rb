# frozen_string_literal: true

require "rails_helper"

RSpec.describe "checks/index", type: :system, js: true do
  def find_check(check)
    Page::Check.find(page, check)
  end

  it "allows deleting checks" do
    check = create(:check)
    sign_in(default_user)

    accept_confirm { find_check(check).delete_icon.click }

    expect(page).to have_flash(:success, "Check deleted")
    expect(page).to have_no_checks
  end

  it "displays active checks in active section" do
    check = create(:check, value: 5)
    sign_in(default_user)

    expect(page).to have_active_check(check.name)
    expect(page).to have_no_inactive_checks
  end

  it "displays inactive checks in inactive section" do
    check = create(:check)
    sign_in(default_user)

    expect(page).to have_inactive_check(check.name)
    expect(page).to have_no_active_checks
  end

  it "displays checks that are below target in inactive section" do
    check = create(:check, value: 5, target_value: 6)
    sign_in(default_user)

    expect(page).to have_inactive_check(check.name)
    expect(page).to have_no_active_checks
  end

  it "links to the edit checks page" do
    check = create(:check)
    sign_in(default_user)

    find_check(check).edit_icon.click

    expect(page).to have_content("Editing Check: #{check.name}")
  end

  it "allows refreshing checks" do
    Test::Check.next_values << 52
    check = create(:check)
    sign_in(default_user)

    find_check(check).refresh_icon.click

    expect(page).to have_active_check(check.name)
  end

  it "displays a button to refresh one target when no active checks" do
    checks = create_pair(:check, value: 5, target_value: 5, target_delta: 1)
    sign_in(default_user)

    click_button("Refresh 1 Target")

    expect(page).to have_active_check(checks.first.name)
    expect(page).to have_inactive_check(checks.second.name)
  end

  it "displays a button to refresh all targets when no active checks" do
    checks = create_pair(:check, value: 5, target_value: 5, target_delta: 1)
    sign_in(default_user)

    click_button("Refresh All 2 Targets")

    expect(page).to have_active_check(checks.first.name)
    expect(page).to have_active_check(checks.second.name)
  end
end
