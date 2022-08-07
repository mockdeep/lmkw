# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :fake_api do
    namespace :trello do
      resources :sessions, only: [:new, :create]
      resources :tokens, only: [:new, :create]
    end

    namespace :github do
      get "/login/oauth/authorize", to: "sessions#authorize", as: :authorize
      post "/session", to: "sessions#create_session"
    end
  end
end
