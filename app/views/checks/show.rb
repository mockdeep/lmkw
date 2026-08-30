# frozen_string_literal: true

class Views::Checks::Show < Views::Base
  # Adapters for this app's own view helpers (see ChecksHelper).
  register_value_helper def checklist_item_data(...) = nil
  register_output_helper def linkify_text(...) = nil

  def initialize(check:, cards:)
    @check = check
    @cards = cards
  end

  def view_template
    div(class: "check-details") do
      h1 { @check.name }

      p(class: "no-items") { "No cards found in this list" } if @cards.empty?

      div(class: "checklists-grid") do
        @cards.each { |card| checklists(card) }
      end

      link_to("Back to Checks", checks_path, class: "btn-primary")
    end
  end

  private

  def checklists(card)
    card.checklists.each do |checklist|
      items = checklist.incomplete_items
      checklist_section(card, checklist, items) if items.any?
    end
  end

  def checklist_section(card, checklist, items)
    div(class: "checklist") do
      div(class: "checklist-card-name") do
        link_to(card.name, card.url, target: "_blank", rel: "noopener")
      end
      h6 { checklist.name }
      ul { items.each { |item| checklist_item(card, item) } }
    end
  end

  def checklist_item(card, item)
    li do
      label_tag("item_#{item.id}") do
        check_box_tag(
          "item_#{item.id}",
          "1",
          item.complete?,
          data: checklist_item_data(@check, card, item),
        )
        linkify_text(item.name)
      end
    end
  end
end
