# frozen_string_literal: true

class User < ApplicationRecord
  class SessionFind
    include JunkDrawer::Callable

    def call(session)
      user = User.find_by(id: session[:user_id])

      unless user
        session.clear
        raise ActiveRecord::RecordNotFound
      end

      user
    end
  end
end
