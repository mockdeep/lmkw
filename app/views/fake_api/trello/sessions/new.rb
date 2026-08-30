# frozen_string_literal: true

class Views::FakeApi::Trello::Sessions::New < Views::Base
  def view_template
    form_with(url: trello_sessions_path, method: :post) do |form|
      form.label(:user, "Email or Username")
      form.email_field(:user)
      form.submit("Continue")
    end
  end
end
