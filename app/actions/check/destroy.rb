# frozen_string_literal: true

class Check < ApplicationRecord
  class Destroy
    include JunkDrawer::Callable

    def call(check)
      ActiveRecord::Base.transaction do
        check.update!(latest_count: nil)
        check.counts.delete_all
        check.target.delete
        check.destroy!
      end
    end
  end
end
