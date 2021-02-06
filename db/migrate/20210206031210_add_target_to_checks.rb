# frozen_string_literal: true

class AddTargetToChecks < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :checks, :target, :integer, null: false, default: 0
    end
  end
end
