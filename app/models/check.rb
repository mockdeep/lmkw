# frozen_string_literal: true

class Check < ApplicationRecord
  belongs_to :user
  belongs_to :integration
  has_one :target, dependent: :delete, class_name: "Check::Target"
  has_many :counts, class_name: "CheckCount", dependent: :delete_all
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :integration_id, :user_id, :target, presence: true
  accepts_nested_attributes_for :target, update_only: true
  scope(
    :last_counted_before,
    lambda { |timestamp|
      left_joins(:counts)
          .having(
            "MAX(check_counts.created_at) < ? OR COUNT(check_counts) = 0",
            timestamp,
          )
          .group("checks.id")
    },
  )

  class << self
    def model_name
      ActiveModel::Name.new(base_class)
    end
  end # class << self

  def active?
    last_value.present? && last_value > target.value
  end

  def refresh=(refresh)
    self.refresh if ["true", true].include?(refresh)
  end

  def refresh
    counts.create!(value: next_count)
    target.refresh
  end

  def next_count
    raise NotImplementedError
  end

  def last_value
    counts.last && counts.last.value
  end
end
