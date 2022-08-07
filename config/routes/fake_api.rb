# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :fake_api do
    namespace :trello do
      resources :sessions, only: [:new, :create]
      resources :tokens, only: [:new, :create]
    end

    namespace :github do
      resources :sessions, only: [:new, :create]
    end
  end
end
