# frozen_string_literal: true

require "rails_helper"

RSpec.describe "user sessions", type: :system do
  it "allows a user to log into their account" do
    user = create(:user)

    sign_in(user)

    expect(page).to have_text(user.email)
    expect(page).to have_link("Account")
    expect(page).to have_no_link("Log In")
  end

  it "does not allow a user to log in with an invalid email" do
    user = create(:user)

    sign_in_with(email: "wrong@email", password: user.password)

    expect(page).to have_flash(:error, "Invalid email or password")
    expect(page).to have_text("Log in to LetMeKnowWhen")
    expect(page).to have_no_text(user.email)
  end

  it "does not allow a user to log in with an invalid password" do
    user = create(:user)

    sign_in_with(email: user.email, password: "wrong password")

    expect(page).to have_flash(:error, "Invalid email or password")
    expect(page).to have_text("Log in to LetMeKnowWhen")
    expect(page).to have_no_text(user.email)
  end

  it "allows a user to log out" do
    user = create(:user)

    sign_in(user)

    click_link("Log Out")

    expect(page).to have_no_text(user.email)
    expect(page).to have_link("Log In")
  end
end
