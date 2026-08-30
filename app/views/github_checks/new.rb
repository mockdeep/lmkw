# frozen_string_literal: true

class Views::GithubChecks::New < Views::Base
  def initialize(check:, integration:)
    @check = check
    @integration = integration
  end

  def view_template
    CheckNameForm(
      check: @check,
      url: github_integration_checks_path(@integration),
    )
  end
end
