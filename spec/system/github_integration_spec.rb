# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GitHub integration", type: :system, js: true do
  def github_params
    { email: ENV.fetch("GITHUB_EMAIL"), password: ENV.fetch("GITHUB_PASSWORD") }
  end

  def start_new_check
    expect(page).to have_heading("Checks")
    click_link("+ New Check")

    expect(page).to have_text("Pick an integration")
  end

  def authenticate_with_github
    click_link("GitHub")

    expect(page).to have_text("First time GitHub integration")

    click_link("Authenticate with GitHub")
    fill_in("Username or email", with: github_params[:email])
    fill_in("Password", with: github_params[:password])
    click_button("Sign in")
    # click_button("Authorize")
  end

  def create_github_check(name:)
    input_name(name)

    expect(page).to have_heading("Checks")
  end

  def input_name(name)
    # wait to allow time to copy/paste email verification code if necessary
    wait_time = fake_apis? ? Capybara.default_max_wait_time : 10.minutes
    expect(page).to have_text("Name your check", wait: wait_time)
    fill_in("Name", with: name)
    click_button("Done")
  end

  it "allows a user to configure a Trello integration" do
    sign_in(User.create!(user_params))
    start_new_check

    authenticate_with_github
    create_github_check(name: "Pulls for Me")

    expect(page).to have_check("Pulls for Me")
  end
end
