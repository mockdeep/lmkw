# frozen_string_literal: true

class Views::CheckCounts::New < Views::Base
  def initialize(check:, count:)
    @check = check
    @count = count
  end

  def view_template
    h1 do
      plain("Editing Count for Check: ")
      em { @check.name }
    end

    form_with(model: @count, url: check_counts_path(@check)) do |form|
      ErrorExplanation(model: @count)

      div(class: "field") do
        form.label(:value)
        form.number_field(:value, value: @check.last_value, required: true)
      end

      div(class: "actions") { form.submit("Update Count") }
    end
  end
end
