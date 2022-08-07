# frozen_string_literal: true

module FakeApi; end

class FakeApi::Github::SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def new
    session[:state] = params[:state]
  end

  def create
    state = session[:state]
    redirect_to(github_integrations_create_path(code: "some_code", state:))
  end
end
