# frozen_string_literal: true

Rails.application.configure do
  config.x.github.client_id = ENV.fetch("GITHUB_CLIENT_ID")
  config.x.github.client_secret = ENV.fetch("GITHUB_CLIENT_SECRET")
  config.x.trello.developer_public_key =
    ENV.fetch("LMKW_TRELLO_DEVELOPER_PUBLIC_KEY")

  if Rails.env.test? && ENV["FAKE_APIS"] == "false"
    config.x.github.email = ENV.fetch("GITHUB_EMAIL")
    config.x.github.password = ENV.fetch("GITHUB_PASSWORD")
    config.x.trello.email = ENV.fetch("LMKW_DEV_TRELLO_EMAIL")
    config.x.trello.password = ENV.fetch("LMKW_DEV_TRELLO_PASSWORD")
  end
end
