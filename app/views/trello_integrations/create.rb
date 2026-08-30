# frozen_string_literal: true

# The Trello callback puts the token in the URL fragment; this script rewrites
# it as a query string and reloads so the controller can read it.
class Views::TrelloIntegrations::Create < Views::Base
  def view_template
    javascript_include_tag("trello_redirect")
  end
end
