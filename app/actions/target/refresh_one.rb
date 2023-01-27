# frozen_string_literal: true

class Target::RefreshOne
  include JunkDrawer::Callable

  def call(user)
    unreached_goal_targets = user.targets.unreached_goal.order(:next_refresh_at)

    return if unreached_goal_targets.none?

    target = unreached_goal_targets.preload(check: :latest_count).first

    Target::Refresh.call(target, force: true)
  end
end
