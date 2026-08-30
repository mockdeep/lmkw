# frozen_string_literal: true

class Views::TrelloChecks::New < Views::Base
  def initialize(check:, integration:)
    @check = check
    @integration = integration
  end

  def view_template
    case @check.next_step
    when "board_id" then board_id_step
    when "list_id" then list_id_step
    when "name" then name_step
    end
  end

  private

  def board_id_step
    h2 { "Pick a board" }

    form_with(model: @check, url: step_path, method: :get) do |form|
      form.label(:board_id, "Boards")
      form.collection_select(:board_id, @check.fetch_boards, :id, :name)

      form.submit("Next")
    end
  end

  def list_id_step
    h2 { "Pick a list" }

    form_with(model: @check, url: step_path, method: :get) do |form|
      form.hidden_field(:board_id)
      form.label(:list_id, "Lists")
      form.collection_select(:list_id, @check.lists, :id, :name)

      form.submit("Next")
    end
  end

  def name_step
    url = trello_integration_checks_path(@integration)

    CheckNameForm(check: @check, url:) do |form|
      form.hidden_field(:board_id)
      form.hidden_field(:list_id)
    end
  end

  def step_path
    new_trello_integration_check_path(@integration)
  end
end
