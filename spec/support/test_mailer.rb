# frozen_string_literal: true

module Test
  class MailerBody < Phlex::HTML
    def view_template
      p { "hello body" }
    end
  end

  # Exercises the layout wiring in ApplicationMailer; the app has no mailer
  # views of its own yet.
  class Mailer < ApplicationMailer
    def hello
      mail(to: "to@example.com") do |format|
        format.html { render(MailerBody.new) }
        format.text { render(plain: "plain body") }
      end
    end
  end
end
