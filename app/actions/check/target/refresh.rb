# frozen_string_literal: true

class Check < ApplicationRecord
  class Target < ApplicationRecord
    class Refresh
      include JunkDrawer::Callable

      def call(target)
        return if target.next_refresh_at > Time.zone.now

        next_value = [target.goal_value, target.value - target.delta].max

        target.update!(next_refresh_at: Time.zone.tomorrow, value: next_value)
      end
    end
  end
end
