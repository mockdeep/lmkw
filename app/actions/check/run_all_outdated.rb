# frozen_string_literal: true

class Check < ApplicationRecord
  class RunAllOutdated
    include JunkDrawer::Callable

    def call
      stale_checks.find_each(&Check::Refresh)
    end

    private

    def stale_checks
      Check.last_counted_before(5.minutes.ago).preload(:target)
    end
  end
end
