# frozen_string_literal: true

class Check < ApplicationRecord
  class Refresh
    include JunkDrawer::Callable

    def call(check)
      check.counts.create!(value: check.next_count) unless check.manual?
      Check::Target::Refresh.call(check.target)
    end
  end
end
