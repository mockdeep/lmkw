# frozen_string_literal: true

require "English"
module ChecksHelper
  def checklist_item_data(check, card, item)
    {
      action: "change->checklist-item#toggle",
      controller: "checklist-item",
      checklist_item_card_id_value: card.id,
      checklist_item_item_id_value: item.id,
      checklist_item_url_value: update_checklist_item_check_path(check),
    }
  end

  def linkify_text(text)
    result = "".html_safe
    pos = 0
    text.scan(%r{https?://\S+}) do |url|
      match = $LAST_MATCH_INFO
      result << h(text[pos...match.begin(0)])
      result << url_link(url)
      pos = match.end(0)
    end
    result << h(text[pos..])
  end

  private

  def url_link(url)
    link_to("(link)", url, target: "_blank", rel: "noopener")
  end
end
