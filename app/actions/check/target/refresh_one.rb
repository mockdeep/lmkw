# frozen_string_literal: true

class Check < ApplicationRecord
  class Target < ApplicationRecord
    class RefreshOne
      include JunkDrawer::Callable

      def call(user)
        unreached_goal_targets =
          user.targets.unreached_goal.order(:next_refresh_at)

        return unless unreached_goal_targets.any?

        target = unreached_goal_targets.preload(check: :latest_count).first

        Check::Target::Refresh.call(target, force: true)
      end
    end
  end
end
