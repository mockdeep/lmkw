# frozen_string_literal: true

class User < ApplicationRecord
  class RequestFind
    include JunkDrawer::Callable

    def call(request)
      if request.session.key?(:user_id)
        User::SessionFind.call(request.session)
      else
        NullUser.new
      end
    end
  end
end
