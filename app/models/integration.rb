# frozen_string_literal: true

class Integration < ApplicationRecord
  belongs_to :user
  validates :type, :user_id, presence: true
  validates :type, uniqueness: { scope: :user_id }

  scope :github, -> { where(type: "Integration::Github") }
  scope :trello, -> { where(type: "Integration::Trello") }
end
