# frozen_string_literal: true

class TargetsController < ApplicationController
  def update
    current_user.targets.unreached_goal.each do |target|
      Check::Target::Refresh.call(target, force: true)
    end

    redirect_to(checks_path)
  end
end
