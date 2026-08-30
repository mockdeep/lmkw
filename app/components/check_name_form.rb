# frozen_string_literal: true

class Components::CheckNameForm < Components::Base
  def initialize(check:, url:)
    @check = check
    @url = url
  end

  # Yields the form builder so callers can add their own hidden fields.
  def view_template(&block)
    h2 { "Name your check" }

    form_with(model: @check, url: @url) do |form|
      yield(form) if block
      form.label(:name)
      form.text_field(:name)

      form.submit("Done")
    end
  end
end
