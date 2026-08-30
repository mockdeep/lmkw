# frozen_string_literal: true

class Views::Checks::New < Views::Base
  def view_template
    div(class: "header") { h2 { "Pick an integration" } }

    div(class: "card-list") do
      card(icon: "trello") { link_to("Trello", new_trello_integration_path) }
      card(icon: "github") { link_to("GitHub", new_github_integration_path) }
      card { link_to("manual", new_manual_integration_path) }
    end
  end

  private

  def card(icon: nil)
    div(class: "card") do
      h3 do
        if icon
          Icon("fab", icon, class: "fa-lg")
          whitespace
        end
        yield
      end
    end
  end
end
