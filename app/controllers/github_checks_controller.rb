# frozen_string_literal: true

class GithubChecksController < ApplicationController
  def new
    render(locals: { check:, integration: })
  end

  def create
    check.save!
    Check::Refresh.call(check)

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
      integration:,
      target_attributes: {},
    }
  end

  def check_params
    check_params =
      if params.key?(:check)
        params.expect(check: [:name])
      else
        {}
      end
    check_params.merge(base_params)
  end
end
