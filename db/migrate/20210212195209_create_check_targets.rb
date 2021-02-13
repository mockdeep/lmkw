# frozen_string_literal: true

class CreateCheckTargets < ActiveRecord::Migration[6.1]
  def change
    create_check_targets
    update_checks
    remove_target_column
  end

  private

  def create_check_targets
    create_table :check_targets do |t|
      t.bigint :value, null: false
      t.references :check,
                   foreign_key: true,
                   null: false,
                   index: { unique: true }

      t.timestamps
    end
  end

  def update_checks
    reversible do |dir|
      dir.up do
        Check.find_each { |check| check.create_target(value: check[:target]) }
      end
    end
  end

  def remove_target_column
    safety_assured do
      remove_column :checks, :target, :integer, default: 0, null: false
    end
  end
end
