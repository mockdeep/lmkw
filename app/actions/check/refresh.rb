# frozen_string_literal: true

class Check < ApplicationRecord
  class Refresh
    include JunkDrawer::Callable

    def call(check)
      unless check.manual?
        count = check.counts.create!(value: check.next_count)
        check.update!(latest_count: count)
      end
      Check::Target::Refresh.call(check.target)
    end
  end
end
