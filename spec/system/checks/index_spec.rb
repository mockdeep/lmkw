# frozen_string_literal: true

require "rails_helper"

RSpec.describe "checks/index", type: :system, js: true do
  def find_check(check)
    Page::Check.find(page, check)
  end

  it "allows deleting checks" do
    check = create_check
    sign_in(check.user)

    accept_confirm { find_check(check).delete_icon.click }

    expect(page).to have_flash(:success, "Check deleted")
    expect(page).to have_no_checks
  end

  it "displays active checks in active section" do
    check = create_check(counts: [{ value: 5 }])
    sign_in(check.user)

    expect(page).to have_active_check(check.name, text: check.message)
    expect(page).to have_no_inactive_checks
  end

  it "displays inactive checks in inactive section" do
    check = create_check
    sign_in(check.user)

    expect(page).to have_inactive_check(check.name, text: check.message)
    expect(page).to have_no_active_checks
  end

  it "displays checks that are below target in inactive section" do
    check = create_check(counts: [{ value: 5 }], target: 6)
    sign_in(check.user)

    expect(page).to have_inactive_check(check.name, text: check.message)
    expect(page).to have_no_active_checks
  end

  it "links to the edit checks page" do
    check = create_check
    sign_in(check.user)

    find_check(check).edit_icon.click

    expect(page).to have_content("Editing Check: #{check.name}")
  end

  it "allows refreshing checks" do
    check = create_check
    sign_in(check.user)

    find_check(check).refresh_icon.click

    expect(page).to have_active_check(check.name, text: check.message)
  end
end
