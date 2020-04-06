# frozen_string_literal: true

class GithubChecksController < ApplicationController
  def new
    render(locals: { check: check, integration: integration })
  end

  def create
    check.save!

    redirect_to(checks_path)
  end

  private

  def check
    Check::Github::UserHasAssignedPullRequests.new(check_params)
  end

  def integration
    @integration ||=
      current_user.integrations.find(params.fetch(:github_integration_id))
  end

  def check_params
    check_params =
      if params.key?(:check)
        params.require(:check).permit(:name)
      else
        {}
      end
    check_params.merge(user: current_user, integration: integration)
  end
end
