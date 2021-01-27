# frozen_string_literal: true

class Check < ApplicationRecord
  belongs_to :user
  belongs_to :integration
  has_many :counts, class_name: "CheckCount", dependent: :delete_all
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :integration_id, :user_id, presence: true
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

  def refresh
    raise NotImplementedError
  end

  def last_value
    counts.last && counts.last.value
  end
end
