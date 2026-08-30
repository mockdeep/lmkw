# frozen_string_literal: true

require "action_mailer"

class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  # Phlex renders HTML only, so the text part is left unwrapped.
  layout(-> { Components::MailerLayout if formats.include?(:html) })
end
