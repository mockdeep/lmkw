# frozen_string_literal: true

class GithubChecksController < ApplicationController
  def new
    render(locals: { check: check, integration: integration })
  end

  def create
    check.save!
    check.refresh

    redirect_to(checks_path)
  end

  private

  def check
    @check ||= Check::Github::UserHasAssignedPullRequests.new(check_params)
  end

  def integration
    @integration ||=
      current_user.integrations.find(params.fetch(:github_integration_id))
  end

  def base_params
    {
      user: current_user,
      integration: integration,
      target_attributes: { value: 0 },
    }
  end

  def check_params
    check_params =
      if params.key?(:check)
        params.require(:check).permit(:name)
      else
        {}
      end
    check_params.merge(base_params)
  end
end
