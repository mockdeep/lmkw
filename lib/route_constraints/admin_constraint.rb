# frozen_string_literal: true

class AdminConstraint
  def matches?(request)
    User::RequestFind.call(request).admin?
  end
end
