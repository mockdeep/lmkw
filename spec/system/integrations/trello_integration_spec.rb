# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Trello integration", type: :system, js: true do
  def trello_email
    Rails.configuration.x.trello.email
  end

  def trello_password
    Rails.configuration.x.trello.password
  end

  def start_new_check
    expect(page).to have_heading("Checks")
    click_link("+ New Check")

    expect(page).to have_text("Pick an integration")
  end

  def authenticate_with_trello
    click_link("Trello")

    expect(page).to have_text("First time Trello integration")

    click_link("Authenticate with Trello")
    click_link("Log in")
    fill_in("user", with: trello_email)
    click_button("Log in with Atlassian")
    fill_in("password", with: trello_password)
    click_button("Log in")
    Capybara.using_wait_time(30) { click_button("Allow") }
  end

  def create_trello_check(board:, list:, name:)
    select_board(board)
    select_list(list)
    input_name(name)

    expect(page).to have_heading("Checks")
  end

  def select_board(board)
    expect(page).to have_text("Pick a board")

    select(board, from: "Boards")
    click_button("Next")
  end

  def select_list(list)
    expect(page).to have_text("Pick a list")

    select(list, from: "Lists")
    click_button("Next")
  end

  def input_name(name)
    expect(page).to have_text("Name your check")
    fill_in("Name", with: name)
    click_button("Done")
  end

  it "allows a user to configure a Trello integration" do
    sign_in(default_user)
    start_new_check

    authenticate_with_trello
    create_trello_check(board: "Dev Board", list: "Inbox", name: "Inbox cards")

    expect(page).to have_check("Inbox cards")
  end
end
