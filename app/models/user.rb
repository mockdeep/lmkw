# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :integrations, dependent: :restrict_with_exception
  has_many :checks, dependent: :restrict_with_exception
  has_many :targets, through: :checks

  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP

  def logged_in?
    true
  end
end
