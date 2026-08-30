# frozen_string_literal: true

class Views::Accounts::Show < Views::Base
  CONFIRM = "Are you sure? This cannot be undone."

  def initialize(user:)
    @user = user
  end

  def view_template
    h1 { "My Account" }

    form_with(model: @user, url: account_path) do |form|
      ErrorExplanation(model: @user)

      div(class: "field") do
        form.label(:email)
        form.email_field(:email, required: true)
      end

      div(class: "actions") { form.submit("Update Account") }
    end

    delete_button
  end

  private

  def delete_button
    form_data = { data: { turbo: true, turbo_confirm: CONFIRM } }
    button_to("Delete Account", account_path, method: :delete, form: form_data)
  end
end
