# frozen_string_literal: true

module FakeApi; end

class FakeApi::Trello::TokensController < ApplicationController
  skip_before_action :authenticate_user

  def new
    session["return_url"] = params["returnUrl"] if params["returnUrl"]

    request_key = params["requestKey"]
    render(Views::FakeApi::Trello::Tokens::New.new(request_key:))
  end

  def create
    redirect_to("#{session["return_url"]}#token=fake-trello-token")
  end
end
