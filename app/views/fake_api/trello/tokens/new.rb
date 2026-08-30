# frozen_string_literal: true

class Views::FakeApi::Trello::Tokens::New < Views::Base
  def initialize(request_key:)
    @request_key = request_key
  end

  def view_template
    if @request_key
      form_with(url: trello_tokens_path, method: :post) do |form|
        form.submit("Allow")
      end
    else
      link_to("Log in", new_trello_session_path)
    end
  end
end
