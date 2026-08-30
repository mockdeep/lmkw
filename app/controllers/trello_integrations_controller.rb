# frozen_string_literal: true

class TrelloIntegrationsController < ApplicationController
  def new
    integration = current_user.integrations.trello.first
    if integration
      redirect_to(new_trello_integration_check_path(integration))
    else
      url = trello_authorize_url
      render(Views::TrelloIntegrations::New.new(authorize_url: url))
    end
  end

  def create
    # first render needs JS to reformat "#" in URL to "?"
    unless params.key?(:token)
      return render(Views::TrelloIntegrations::Create.new)
    end

    integration = Integration::Trello.create!(integration_params)

    redirect_to(new_trello_integration_check_path(integration))
  end

  private

  def integration_params
    { user: current_user, member_token: params.fetch(:token) }
  end

  def trello_authorize_url
    return_url = trello_integrations_create_url
    Integration::Trello.authorize_url(return_url:)
  end
end
