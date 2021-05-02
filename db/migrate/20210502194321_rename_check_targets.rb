# frozen_string_literal: true

class RenameCheckTargets < ActiveRecord::Migration[6.1]
  def change
    safety_assured { rename_table :check_targets, :targets }
  end
end
