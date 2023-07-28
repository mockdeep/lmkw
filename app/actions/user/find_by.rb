# frozen_string_literal: true

class User::FindBy
  include JunkDrawer::Callable

  def call(**)
    User.find_by(**) || NullUser.new
  end
end
