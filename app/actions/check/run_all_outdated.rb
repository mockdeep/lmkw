# frozen_string_literal: true

class Check < ApplicationRecord
  class RunAllOutdated
    include JunkDrawer::Callable

    def call
      Check.last_counted_before(5.minutes.ago).find_each(&:refresh)
    end
  end
end
