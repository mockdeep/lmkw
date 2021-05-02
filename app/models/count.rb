# frozen_string_literal: true

class Count < ApplicationRecord
  belongs_to :check
  validates :check_id, :value, presence: true
end
