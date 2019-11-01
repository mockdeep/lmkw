# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP

  class << self
    def find_by(args)
      super || NullUser.new
    end

    def find(id)
      id ? super : NullUser.new
    end # class << self
  end

  def logged_in?
    true
  end

  def admin?
    false
  end
end
