# frozen_string_literal: true

class Views::Accounts::New < Views::Base
  def initialize(user:)
    @user = user
  end

  def view_template
    h1 { "New Account" }

    form_with(model: @user, url: account_path) do |form|
      ErrorExplanation(model: @user)

      field(form, :email) { form.email_field(:email, required: true) }
      field(form, :password) { form.password_field(:password, required: true) }
      field(form, :password_confirmation) do
        form.password_field(:password_confirmation, required: true)
      end

      div(class: "actions") { form.submit("Create Account") }
    end
  end

  private

  def field(form, name)
    div(class: "field") do
      form.label(name)
      yield
    end
  end
end
