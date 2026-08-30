# frozen_string_literal: true

class Views::Checks::Index < Views::Base
  def initialize(checks:, unreached_goal_targets:)
    @active_checks, @inactive_checks = checks.partition(&:active?)
    @unreached_goal_targets = unreached_goal_targets
  end

  def view_template
    div(class: "header") do
      link_to("+ New Check", new_check_path, class: "btn-primary new-check-btn")
    end

    div(class: "active") do
      h2 { "Active Checks" }

      if @active_checks.any?
        CheckList(checks: @active_checks)
      else
        no_active_checks
      end
    end

    div(class: "inactive") do
      hr
      h2 { "Inactive Checks" }

      CheckList(checks: @inactive_checks)
    end
  end

  private

  def no_active_checks
    h3 { "Congrats you have no active checks!" }

    return if @unreached_goal_targets.empty?

    plain("There are checks with unreached goals.")
    refresh_button("Refresh 1 Target", "one")
    return unless @unreached_goal_targets.many?

    count = @unreached_goal_targets.count
    refresh_button("Refresh All #{count} Targets", "all")
  end

  def refresh_button(label, checks)
    button_to(
      label,
      target_refreshes_path(checks:),
      remote: false,
      class: "btn-primary",
    )
  end
end
