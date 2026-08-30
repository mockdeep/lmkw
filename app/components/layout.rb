# frozen_string_literal: true

class Components::Layout < Components::Base
  FAVICON_COLORS = ["black", "blue", "purple", "orange"].freeze
  FONT_AWESOME = "@fortawesome/fontawesome-free/css/all.min"
  HOTKEYS_ACTION = "keydown@document->hotkeys#handleKeydown"
  STYLESHEET_OPTIONS = { media: "all", "data-turbo-track": "reload" }.freeze

  def view_template(&)
    doctype

    html do
      head { head_tags }

      body(data: { controller: "hotkeys", action: HOTKEYS_ACTION }) do
        logo
        nav
        main(&)
      end
    end
  end

  private

  def head_tags
    title { "LetMeKnowWhen" }
    csrf_meta_tags
    csp_meta_tag
    meta(name: "viewport", content: "width=device-width, initial-scale=1.0")

    stylesheet_link_tag(FONT_AWESOME, **STYLESHEET_OPTIONS)
    stylesheet_link_tag("application", **STYLESHEET_OPTIONS)
    javascript_include_tag("application", "data-turbo-track": "reload")
    favicon_link_tag("fat-dot-#{FAVICON_COLORS.sample}.ico")
  end

  def logo
    div(class: "logo") do
      image_tag("LMKW-logo-black.png", height: 100)
      br
      div(class: "title") { "Let Me Know When" }
    end
  end

  def nav
    div(class: "nav") do
      current_user.logged_in? ? logged_in_nav : logged_out_nav
      flashes
    end
  end

  def logged_in_nav
    plain(current_user.email)
    br
    link_to("Account", account_path)
    button_to("Log Out", session_path, method: :delete)
  end

  def logged_out_nav
    link_to("Log In", new_session_path) unless current_page?(new_session_path)
    link_to("Sign Up", new_account_path)
  end

  def flashes
    div(class: "flashes") do
      flash.each do |type, message|
        div(class: "flash-#{type}") { message }
      end
    end
  end
end
