# frozen_string_literal: true

class Check < ApplicationRecord
  belongs_to :user
  belongs_to :integration
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  class << self
    def model_name
      ActiveModel::Name.new(base_class)
    end
  end # class << self
end
