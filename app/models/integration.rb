# frozen_string_literal: true

class Integration < ApplicationRecord
  belongs_to :user
  has_many :checks, dependent: :delete_all
  validates :type, :user_id, presence: true
  validates :type, uniqueness: { scope: :user_id }

  scope :github, -> { where(type: "Integration::Github") }
  scope :trello, -> { where(type: "Integration::Trello") }
  scope :manual, -> { where(type: "Integration::Manual") }
end
