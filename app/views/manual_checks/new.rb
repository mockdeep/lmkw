# frozen_string_literal: true

class Views::ManualChecks::New < Views::Base
  def initialize(check:, integration:)
    @check = check
    @integration = integration
  end

  def view_template
    return unless @check.next_step == "name"

    CheckNameForm(
      check: @check,
      url: manual_integration_checks_path(@integration),
    )
  end
end
