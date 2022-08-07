# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :fake_api do
    get "/1/authorize", to: "trello#authorize", as: :authorize
    get "/login", to: "trello#login"
    post "/login", to: "trello#create_login"
    post "/1/token/approve", to: "trello#create_token", as: :token
  end
end
