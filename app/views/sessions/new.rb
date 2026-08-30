# frozen_string_literal: true

class Views::Sessions::New < Views::Base
  def view_template
    h1 { "Log in to LetMeKnowWhen" }

    form_with(scope: :session, url: session_path) do |form|
      div(class: "field") do
        form.label(:email)
        form.email_field(:email, required: true)
      end

      div(class: "field") do
        form.label(:password)
        form.password_field(:password, required: true)
      end

      div(class: "actions") { form.submit("Log In") }
    end
  end
end
