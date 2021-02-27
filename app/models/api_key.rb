# frozen_string_literal: true

class ApiKey < ApplicationRecord
  has_secure_token :value

  belongs_to :user

  validates :name, :user_id, presence: true

  def ==(other)
    if other.is_a?(String)
      ActiveSupport::SecurityUtils.secure_compare(other, value)
    else
      super
    end
  end
end
