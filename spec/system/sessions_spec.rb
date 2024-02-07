# frozen_string_literal: true

require "rails_helper"

RSpec.describe "user sessions" do
  it "allows a user to log into their account" do
    sign_in(default_user)

    expect(page).to have_text(default_user.email)
      .and have_link("Account")
      .and have_no_link("Log In")
  end

  it "does not allow a user to log in with an invalid email" do
    sign_in_with(email: "wrong@email", password: default_user.password)

    expect(page).to have_flash(:error, "Invalid email or password")
      .and have_text("Log in to LetMeKnowWhen")
      .and have_no_text(default_user.email)
  end

  it "does not allow a user to log in with an invalid password" do
    sign_in_with(email: default_user.email, password: "wrong password")

    expect(page).to have_flash(:error, "Invalid email or password")
      .and have_text("Log in to LetMeKnowWhen")
      .and have_no_text(default_user.email)
  end

  it "allows a user to log out" do
    sign_in(default_user)

    click_link("Log Out")

    expect(page).to have_no_text(default_user.email).and have_link("Log In")
  end
end
