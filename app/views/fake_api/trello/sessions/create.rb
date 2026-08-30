# frozen_string_literal: true

class Views::FakeApi::Trello::Sessions::Create < Views::Base
  def view_template
    form_with(url: trello_sessions_path, method: :post) do |form|
      form.label(:password)
      form.password_field(:password)
      form.submit("Log in")
    end
  end
end
