# frozen_string_literal: true

if fake_apis?
  require "capybara_discoball"
  require_relative "fake_api/trello/implementation"
  require_relative "fake_api/trello/server"

  Capybara::Discoball.spin(FakeApi::Trello::Server) do |server|
    FakeApi::Trello::Implementation.endpoint_url = server.url
  end

  RSpec.configuration.before do
    Integration::Trello.implementation = FakeApi::Trello::Implementation
  end
else
  Capybara.default_max_wait_time = 10
end
