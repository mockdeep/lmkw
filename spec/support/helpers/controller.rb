# frozen_string_literal: true

module Helpers
  module Controller
    def login_as(user)
      session[:user_id] = user.id
    end

    def rendered
      Capybara.string(response.body)
    end
  end
end
