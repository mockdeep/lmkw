# frozen_string_literal: true

class Components::CheckList < Components::Base
  def initialize(checks:)
    @checks = checks
  end

  def view_template
    div(class: "card-list") do
      @checks.each { |check| card(check) }
    end
  end

  private

  def card(check)
    div(class: "card") do
      div(class: "card-main") { card_main(check) }
      div(class: "card-actions") { card_actions(check) }
    end
  end

  def card_main(check)
    values(check)

    h3 do
      Icon(*check.icon, class: "fa-lg")
      whitespace
      plain(check.name)
    end

    p { visit_link(check) }
  end

  def values(check)
    div(class: "check-values") do
      span(class: "check-value") { check.last_value.to_s }
      whitespace
      Icon("fas", "arrow-right", class: "fa-2x")
      whitespace
      span(class: "check-value target-value") { check.target_value.to_s }
    end
  end

  def visit_link(check)
    options = check.manual? ? {} : { target: :_blank, rel: :noreferrer }

    link_to(check.url, options) do
      plain("visit #{check.service}")
      whitespace
      span(class: "fas fa-external-link-alt")
    end
  end

  def card_actions(check)
    refresh_button(check)
    link_to(edit_check_path(check)) { Icon("fas", "pen") }
    if check.is_a?(Check::Trello::ListHasCards)
      link_to(check_path(check)) { Icon("fas", "tasks") }
    end
    delete_button(check)
  end

  def refresh_button(check)
    path = check_path(check, check: { refresh: true })

    button_to(path, method: :patch) { Icon("fas", "sync-alt") }
  end

  def delete_button(check)
    confirm = "delete check? #{check.name}"
    form_data = { data: { turbo: true, turbo_confirm: confirm } }

    button_to(check_path(check), method: :delete, form: form_data) do
      Icon("far", "trash-alt")
    end
  end
end
