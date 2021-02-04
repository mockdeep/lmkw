# frozen_string_literal: true

require "rails_helper"

RSpec.describe "checks/index", type: :system, js: true do
  def find_check(name)
    Page::Check.new(find(".card > h3", text: name))
  end

  it "allows deleting checks" do
    check = create_check
    sign_in(check.user)

    accept_confirm { find_check(check.name).delete_icon.click }

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
end
