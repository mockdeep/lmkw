# frozen_string_literal: true

module FakeApi; end

class FakeApi::Trello::SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def new; end

  def create
    return unless params.key?("password")

    redirect_to(new_trello_token_path(requestKey: "boo"))
  end
end
