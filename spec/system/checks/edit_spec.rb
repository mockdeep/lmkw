# frozen_string_literal: true

require "rails_helper"

RSpec.describe "checks/edit", type: :system, js: true do
  def update_check(check, **params)
    visit(edit_check_path(check))

    params.each do |field, value|
      fill_in(field, with: value)
    end

    click_button("Update Check")
  end

  it "allows editing a check" do
    check = create_check(counts: [{ value: 5 }])
    sign_in(check.user)
    expect(page).to have_active_check(check.name, text: check.message)

    update_check(check, Target: 5)

    expect(page).to have_inactive_check(check.name, text: check.message)
  end
end
