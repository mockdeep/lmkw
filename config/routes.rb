# frozen_string_literal: true

Rails.application.routes.draw do
  require "sidekiq/web"

  mount Sidekiq::Web, at: "/sidekiq", constraints: AdminConstraint.new

  root to: "welcome#index"

  resource :account, only: [:new, :create, :show, :update, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :checks, only: [:index, :new, :edit, :update, :destroy]
  resources :trello_integrations, only: [:new] do
    resources :checks, only: [:new, :create], controller: "trello_checks"
  end

  resources :github_integrations, only: [:new] do
    resources :checks, only: [:new, :create], controller: "github_checks"
  end

  get "/trello_integrations/create", to: "trello_integrations#create"
  get "/github_integrations/create", to: "github_integrations#create"
end
