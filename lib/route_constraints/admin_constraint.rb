# frozen_string_literal: true

class AdminConstraint
  def matches?(request)
    User::SessionFind.call(request.session).admin?
  end
end
