# frozen_string_literal: true

class TargetsController < ApplicationController
  def update
    unreached_goal_targets = current_user.targets.unreached_goal
    unreached_goal_targets.preload(check: :latest_count).each do |target|
      Check::Target::Refresh.call(target, force: true)
    end

    redirect_to(checks_path)
  end
end
