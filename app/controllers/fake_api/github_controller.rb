# frozen_string_literal: true

module FakeApi; end

class FakeApi::GithubController < ApplicationController
  skip_before_action :authenticate_user

  def authorize
    session[:state] = params[:state]
  end

  def create_session
    state = session[:state]
    redirect_to(github_integrations_create_path(code: "some_code", state:))
  end
end
