# frozen_string_literal: true

require "webmock/rspec"

if FakeApis.enabled?
  WebMock.disable_net_connect!(
    allow_localhost: true,
    allow: [/geckodriver/, /chromedriver/],
  )
else
  WebMock.allow_net_connect!
end
