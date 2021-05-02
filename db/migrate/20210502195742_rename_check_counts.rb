# frozen_string_literal: true

class RenameCheckCounts < ActiveRecord::Migration[6.1]
  def change
    safety_assured { rename_table :check_counts, :counts }
  end
end
