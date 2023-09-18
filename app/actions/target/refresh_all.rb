# frozen_string_literal: true

class Target::RefreshAll
  include JunkDrawer::Callable

  def call(user)
    unreached_goal_targets = user.targets.unreached_goal
    unreached_goal_targets.preload(check: :latest_count).find_each do |target|
      Target::Refresh.call(target, force: true)
    end
  end
end
