# frozen_string_literal: true

class Views::TrelloIntegrations::New < Views::Base
  def initialize(authorize_url:)
    @authorize_url = authorize_url
  end

  def view_template
    plain("First time Trello integration")

    link_to("Authenticate with Trello", @authorize_url)
  end
end
