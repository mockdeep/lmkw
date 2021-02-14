# frozen_string_literal: true

class AddTargetColumns < ActiveRecord::Migration[6.1]
  def change
    add_columns
    update_targets
    constrain_columns
  end

  private

  def add_columns
    safety_assured do
      change_table :check_targets, bulk: true do |t|
        t.bigint :delta
        t.bigint :goal_value
        t.datetime :next_refresh_at
      end
    end
  end

  def update_targets
    Check::Target.find_each do |target|
      target.delta ||= 0
      target.goal_value ||= target.value
      target.next_refresh_at ||= 1.day.from_now.beginning_of_day
      target.save!
    end
  end

  def constrain_columns
    safety_assured do
      change_column_null :check_targets, :delta, false
      change_column_null :check_targets, :goal_value, false
      change_column_null :check_targets, :next_refresh_at, false
    end
  end
end
