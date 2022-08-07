# frozen_string_literal: true

module FakeApi; end

class FakeApi::Trello::TokensController < ApplicationController
  skip_before_action :authenticate_user

  def new
    session["return_url"] = params["returnUrl"] if params["returnUrl"]
  end

  def create
    redirect_to("#{session["return_url"]}#token=fake-trello-token")
  end
end
