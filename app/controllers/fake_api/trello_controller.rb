# frozen_string_literal: true

module FakeApi; end

class FakeApi::TrelloController < ApplicationController
  skip_before_action :authenticate_user

  def authorize
    session["return_url"] = params["returnUrl"] if params["returnUrl"]
  end

  def login; end

  def create_login
    redirect_to(authorize_path(requestKey: "boo")) if params.key?("password")
  end

  def create_token
    redirect_to("#{session["return_url"]}#token=fake-trello-token")
  end
end
