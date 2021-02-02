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
end
