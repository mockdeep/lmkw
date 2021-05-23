# frozen_string_literal: true

module Helpers::Controller
  def login_as(user)
    session[:user_id] = user.id
  end

  def rendered
    Capybara.string(response.body)
  end
end
