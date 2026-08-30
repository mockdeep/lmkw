# frozen_string_literal: true

class Components::MailerLayout < Components::Base
  include Phlex::Rails::Layout

  def view_template(&)
    doctype

    html do
      head { head_tags }

      body(&)
    end
  end

  private

  def head_tags
    # Phlex denies `http-equiv` by default because it can drive CSP and
    # refresh redirects; `safe` opts this benign charset declaration out.
    meta(
      "http-equiv": safe("Content-Type"),
      content: "text/html; charset=utf-8",
    )
    style { "/* Email styles need to be inline */" }
  end
end
