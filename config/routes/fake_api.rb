# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :fake_api do
    namespace :trello do
      get "/1/authorize", to: "sessions#authorize", as: :authorize
      get "/login", to: "sessions#login"
      post "/login", to: "sessions#create_login"
      post "/1/token/approve", to: "sessions#create_token", as: :token
    end

    namespace :github do
      get "/login/oauth/authorize", to: "sessions#authorize", as: :authorize
      post "/session", to: "sessions#create_session"
    end
  end
end
