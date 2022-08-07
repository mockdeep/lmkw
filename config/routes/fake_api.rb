# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :fake_api do
    # Trello
    get "/1/authorize", to: "trello#authorize", as: :authorize_trello
    get "/login", to: "trello#login"
    post "/login", to: "trello#create_login"
    post "/1/token/approve", to: "trello#create_token", as: :token

    # Github
    get "/login/oauth/authorize", to: "github#authorize", as: :authorize_github
    post "/github_session", to: "github#create_session"
  end
end
