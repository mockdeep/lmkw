# frozen_string_literal: true

module FakeApi; end

class FakeApi::Trello::SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def authorize
    session["return_url"] = params["returnUrl"] if params["returnUrl"]
  end

  def login; end

  def create_login
    return unless params.key?("password")

    redirect_to(trello_authorize_path(requestKey: "boo"))
  end

  def create_token
    redirect_to("#{session["return_url"]}#token=fake-trello-token")
  end
end
