# frozen_string_literal: true

class Views::Welcome::Index < Views::Base
  def view_template
    plain("Welcome")
  end
end
