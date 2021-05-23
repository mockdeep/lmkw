# frozen_string_literal: true

class Target < ApplicationRecord
  class Refresh
    include JunkDrawer::Callable

    def call(target, force: false)
      return if target.next_refresh_at > Time.zone.now && !force

      next_target_value = [target.goal_value, target.value - target.delta].max

      if force
        next_target_value = decrement_until_active(next_target_value, target)
      end

      target.update!(
        next_refresh_at: Time.zone.tomorrow,
        value: next_target_value,
      )
    end

    private

    def decrement_until_active(next_target_value, target)
      last_check_value = target.check.last_value

      return next_target_value unless last_check_value
      return next_target_value if next_target_value < last_check_value
      return next_target_value if next_target_value == target.goal_value
      return last_check_value if last_check_value == target.goal_value

      last_check_value - 1
    end
  end
end
