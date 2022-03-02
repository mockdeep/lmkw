# frozen_string_literal: true

require "rails_helper"

RSpec.describe "check_counts/new", type: :system, js: true do
  def user_creates_count(check)
    # binding.pry
    click_link(check.name)
    # click_link("Manual Check 100")

    fill_in(:Value, with: 10)

    click_button("Update Count")
  end

  it "allows creating new check counts" do
    check = create(:manual_check)
    sign_in(default_user)

    expect { user_creates_count(check) }
      .to activate_check(check.name).in(page)
  end
end
