# frozen_string_literal: true

Octokit.configure do |config|
  config.connection_options = { request: { open_timeout: 5, timeout: 5 } }
end
