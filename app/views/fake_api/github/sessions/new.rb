# frozen_string_literal: true

class Views::FakeApi::Github::Sessions::New < Views::Base
  def view_template
    form_with(url: github_sessions_path, method: :post) do |form|
      form.label(:login_field, "Username or email address")
      form.text_field(:login_field)

      form.label(:password)
      form.password_field(:password)

      form.submit("Sign in")
    end
  end
end
