# frozen_string_literal: true

module Helpers::Request
  def login_as(user)
    params = { session: { email: user.email, password: user.password } }
    post(session_path, params: params)
  end

  def rendered
    Capybara.string(response.body)
  end
end
