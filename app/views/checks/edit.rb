# frozen_string_literal: true

class Views::Checks::Edit < Views::Base
  def initialize(check:)
    @check = check
  end

  def view_template
    h1 do
      plain("Editing Check: ")
      em { @check.name }
    end

    form_with(model: @check) do |form|
      ErrorExplanation(model: @check)

      field(form, :name) { form.text_field(:name, required: true) }

      form.fields_for(:target) { |target_form| target_fields(target_form) }

      div(class: "actions") { form.submit("Update Check") }
    end
  end

  private

  def target_fields(form)
    field(form, :value, "Target") { form.number_field(:value, required: true) }
    field(form, :delta) { form.number_field(:delta, required: true) }
    field(form, :goal_value, "Goal Target") do
      form.number_field(:goal_value, required: true)
    end
  end

  def field(form, name, label = nil)
    div(class: "field") do
      form.label(name, label)
      yield
    end
  end
end
