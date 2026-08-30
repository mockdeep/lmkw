# frozen_string_literal: true

class Views::GithubIntegrations::New < Views::Base
  def initialize(authorize_url:)
    @authorize_url = authorize_url
  end

  def view_template
    plain("First time GitHub integration")

    link_to("Authenticate with GitHub", @authorize_url)
  end
end
