# frozen_string_literal: true

if FakeApis.enabled?
  require "capybara_discoball"
  require_relative "fake_api/modules"
  require_relative "fake_api/github/implementation"
  require_relative "fake_api/github/server"
  require_relative "fake_api/trello/implementation"

  Capybara::Discoball.spin(FakeApi::Github::Server) do |server|
    FakeApi::Github::Implementation.endpoint_url = server.url
  end

  RSpec.configuration.before(js: true) do
    server = Capybara.current_session.server
    FakeApi::Github::Server.return_url =
      Rails.application.routes.url_helpers.github_integrations_create_url(
        host: server.host,
        port: server.port,
      )
    Integration::Github.implementation = FakeApi::Github::Implementation
    Integration::Trello.implementation = FakeApi::Trello::Implementation
  end
else
  # For integrations like GitHub we need a URL with a constant server port to
  # be configured via their web interface
  Capybara.server_port = 38_091
  Capybara.default_max_wait_time = 10
end
