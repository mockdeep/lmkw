# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :integrations, dependent: :delete_all
  has_many :checks, dependent: :delete_all
  has_many :targets, through: :checks
  has_many :api_keys, dependent: :delete_all

  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP

  def logged_in?
    true
  end
end
