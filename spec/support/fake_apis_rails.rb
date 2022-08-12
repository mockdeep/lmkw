# frozen_string_literal: true

if FakeApis.enabled?
  require_relative "fake_api/modules"
  require_relative "fake_api/github/implementation"
  require_relative "fake_api/trello/client"
  require_relative "fake_api/trello/implementation"

  RSpec.configuration.before(js: true) do
    Integration::Github.implementation = FakeApi::Github::Implementation
    Integration::Trello.client_class = FakeApi::Trello::Client
  end
else
  # For integrations like GitHub we need a URL with a constant server port to
  # be configured via their web interface
  Capybara.server_port = 38_091
  Capybara.default_max_wait_time = 10
end
