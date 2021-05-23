# frozen_string_literal: true

class User::RequestFind
  include JunkDrawer::Callable

  def call(request)
    if request.session.key?(:user_id)
      User::SessionFind.call(request.session)
    elsif request.headers.key?("X-User-Id")
      User::ApiKeyFind.call(request.headers)
    else
      NullUser.new
    end
  end
end
