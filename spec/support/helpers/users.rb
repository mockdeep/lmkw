# frozen_string_literal: true

module Helpers
  module Users
    def user_params
      {
        email: "demo@lmkw.io",
        password: "super-secure",
        password_confirmation: "super-secure",
      }
    end
  end
end
