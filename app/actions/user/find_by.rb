# frozen_string_literal: true

class User::FindBy
  include JunkDrawer::Callable

  def call(**params)
    User.find_by(**params) || NullUser.new
  end
end
