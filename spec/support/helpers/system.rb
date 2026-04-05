# frozen_string_literal: true

require_relative "../capybara/page"

module Helpers::System
  def sign_in(user)
    sign_in_with(email: user.email, password: user.password)
  end

  def sign_in_with(email:, password:)
    visit("/")

    click_on("Log In")

    expect(page).to have_text("Log in to LetMeKnowWhen")

    fill_in("Email", with: email)
    fill_in("Password", with: password)

    click_on("Log In")
  end
end
