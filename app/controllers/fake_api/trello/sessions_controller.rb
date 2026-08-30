# frozen_string_literal: true

module FakeApi; end

class FakeApi::Trello::SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def new
    render(Views::FakeApi::Trello::Sessions::New.new)
  end

  def create
    unless params.key?("password")
      return render(Views::FakeApi::Trello::Sessions::Create.new)
    end

    redirect_to(new_trello_token_path(requestKey: "boo"))
  end
end
