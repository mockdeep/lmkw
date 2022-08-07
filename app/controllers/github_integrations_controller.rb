# frozen_string_literal: true

class GithubIntegrationsController < ApplicationController
  def new
    integration = current_user.integrations.github.first
    if integration
      redirect_to(new_github_integration_check_path(integration))
    else
      render(locals: { github_authorize_url: })
    end
  end

  def create
    if session.delete(:github_state) != params[:state]
      raise ActionController::RoutingError, "Not Found"
    end

    integration = Integration::Github.create!(integration_params)

    redirect_to(new_github_integration_check_path(integration))
  end

  private

  def integration_params
    { user: current_user, code: params.fetch(:code) }
  end

  def github_authorize_url
    session[:github_state] = SecureRandom.hex(16)
    Integration::Github.authorize_url(state: session[:github_state])
  end
end
