# frozen_string_literal: true

require "rails_helper"

RSpec.describe "user account" do
  def sign_up_with(
    email: "demo@lmkw.io",
    password: "secret",
    password_confirmation: password
  )
    visit("/")
    click_link("Sign Up")
    fill_in("Email", with: email)
    fill_in("Password", with: password)
    fill_in("Password confirmation", with: password_confirmation)
    click_button("Create Account")
  end

  def update_account_with(email:)
    click_link("Account")
    fill_in("Email", with: email)

    click_button("Update Account")
  end

  def delete_account
    click_link("Account")

    accept_confirm("Are you sure? This cannot be undone.") do
      click_button("Delete Account")
    end
  end

  it "allows a user to sign up for an account" do
    sign_up_with(email: "demo@lmkw.io")

    expect(page).to have_flash(:success, "Account created")
      .and have_text("demo@lmkw.io")
  end

  it "does not allow user to sign up with invalid email" do
    sign_up_with(email: "boo#boo")

    expect(find_field("Email")).to have_error("Please enter an email address.")
  end

  it "does not allow user to sign up with invalid password" do
    sign_up_with(password: "")

    expect(find_field("Password")).to have_error("Please fill out this field.")
  end

  it "does not allow user to sign up with invalid password confirmation" do
    sign_up_with(password_confirmation: "not the same")

    expect(page).to have_flash(:error, "problem setting up your account")
  end

  it "allows a user to edit their email" do
    sign_up_with(email: "demo@lmkw.io")
    update_account_with(email: "demo2@lmkw.io")

    expect(page).to have_text("demo2@lmkw.io")
  end

  it "allows a user to delete their account" do
    sign_up_with(email: "demo@lmkw.io")

    delete_account

    expect(page).to have_flash(:success, "Account permanently deleted")
      .and have_no_text("demo@lmkw.io")
  end
end
