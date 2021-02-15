# frozen_string_literal: true

class TrelloChecksController < ApplicationController
  def new
    render(locals: { check: check, trello_integration: trello_integration })
  end

  def create
    check.save!
    Check::Refresh.call(check)

    redirect_to(checks_path)
  end

  private

  def check
    @check ||= Check::Trello::ListHasCards.new(check_params)
  end

  def trello_integration
    @trello_integration ||=
      current_user.integrations.find(params.fetch(:trello_integration_id))
  end

  def base_params
    {
      user: current_user,
      integration: trello_integration,
      target_attributes: {},
    }
  end

  def check_params
    check_params =
      if params.key?(:check)
        params.require(:check).permit(:board_id, :list_id, :name)
      else
        {}
      end
    check_params.merge(base_params)
  end
end
