# frozen_string_literal: true

require "rails_helper"

RSpec.describe "checks/edit", type: :system, js: true do
  def find_check(check)
    Page::Check.find(page, check)
  end

  def update_check(check, **params)
    visit(edit_check_path(check))

    params.each { |field, value| fill_in(field, with: value) }

    click_button("Update Check")
  end

  def expect_check_to_activate(check)
    expect(page).to have_inactive_check(check.name)

    yield

    find_check(check).refresh_icon.click

    expect(page).to have_active_check(check.name)
  end

  it "allows editing a check" do
    check = create(:check, count_values: [5])
    sign_in(check.user)
    expect(page).to have_active_check(check.name)

    update_check(check, Target: 5)

    expect(page).to have_inactive_check(check.name)
  end

  it "allows setting a moving target on a check" do
    check = create(:check, count_values: [5])
    sign_in(check.user)

    Test::Check.next_values << 5 << 5
    update_check(check, Target: 5, Delta: 1, "Goal Target": 4)

    expect_check_to_activate(check) { travel(1.day) }
  end
end
