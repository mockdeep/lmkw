# frozen_string_literal: true

class AddLatestCountIdToChecks < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_reference :checks,
                    :latest_count,
                    foreign_key: { to_table: :check_counts }
    end
  end
end
