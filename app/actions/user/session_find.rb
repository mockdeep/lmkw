# frozen_string_literal: true

class User < ApplicationRecord
  class SessionFind
    include JunkDrawer::Callable

    def call(session)
      return NullUser.new unless session.key?(:user_id)

      user = User.find_by(id: session[:user_id])

      unless user
        session.clear
        raise ActiveRecord::RecordNotFound
      end

      user
    end
  end
end
