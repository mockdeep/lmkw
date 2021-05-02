# frozen_string_literal: true

class Target < ApplicationRecord
  attribute :delta, :integer, default: 0
  attribute :goal_value, :integer, default: 0
  attribute :next_refresh_at, :datetime, default: -> { Time.zone.tomorrow }
  attribute :value, :integer, default: 0

  belongs_to :check

  delegate :user, to: :check
  delegate :name, to: :check, prefix: true

  validates :check_id, uniqueness: true
  validates :value,
            :check,
            :delta,
            :goal_value,
            :next_refresh_at,
            presence: true

  scope :unreached_goal, -> { where("goal_value != value") }
end
