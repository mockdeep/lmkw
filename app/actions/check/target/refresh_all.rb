# frozen_string_literal: true

class Check < ApplicationRecord
  class Target < ApplicationRecord
    class RefreshAll
      include JunkDrawer::Callable

      def call(user)
        unreached_goal_targets = user.targets.unreached_goal
        unreached_goal_targets.preload(check: :latest_count).each do |target|
          Check::Target::Refresh.call(target, force: true)
        end
      end
    end
  end
end
