# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :integrations, dependent: :restrict_with_exception
  has_many :checks, dependent: :restrict_with_exception

  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP

  class << self
    def find_by(args)
      super || NullUser.new
    end

    def find(id)
      id ? super : NullUser.new
    end
  end # class << self

  def logged_in?
    true
  end

  def admin?
    false
  end
end
