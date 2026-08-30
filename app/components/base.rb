# frozen_string_literal: true

class Components::Base < Phlex::HTML
  extend Phlex::Rails::HelperMacros

  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::CheckboxTag
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CurrentPage
  include Phlex::Rails::Helpers::FaviconLinkTag
  include Phlex::Rails::Helpers::Flash
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::ImageTag
  include Phlex::Rails::Helpers::JavaScriptIncludeTag
  include Phlex::Rails::Helpers::LabelTag
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Pluralize
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::StyleSheetLinkTag

  # Exposed by ApplicationController via `helper_method`.
  register_value_helper def current_user(...) = nil
end
