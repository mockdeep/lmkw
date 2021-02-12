# frozen_string_literal: true

class Check < ApplicationRecord
  class Target < ApplicationRecord
    belongs_to :check
    validates :value, :check, presence: true
  end
end
