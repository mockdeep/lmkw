# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :fake_api do
    namespace :trello do
      resources :sessions, only: [:new, :create]
      resources :tokens, only: [:new, :create]
    end

    namespace :github do
      get "/login/oauth/authorize", to: "sessions#new"
      resources :sessions, only: [:create]
    end
  end
end
