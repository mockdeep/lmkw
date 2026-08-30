# frozen_string_literal: true

class Components::ErrorExplanation < Components::Base
  def initialize(model:)
    @model = model
  end

  def view_template
    return if @model.errors.empty?

    div(class: "error-explanation") do
      h2 do
        plain(pluralize(@model.errors.count, "error"))
        plain(" problems with your signup:")
      end
      ul do
        @model.errors.full_messages.each { |message| li { message } }
      end
    end
  end
end
