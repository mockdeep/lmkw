# frozen_string_literal: true

class Check < ApplicationRecord
  class RunAllOutdated
    include JunkDrawer::Callable

    def call
      Check.joins(:counts)
           .having("MAX(check_counts.created_at) < ?", 1.hour.ago)
           .group("checks.id")
    end
  end
end
