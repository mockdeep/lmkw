# frozen_string_literal: true

class Integration::Trello < Integration
  validates :member_token, presence: true
  store_accessor :data, :member_token
  delegate :fetch_board, :fetch_boards, :fetch_lists, to: :client

  def self.client_class=(client_class)
    @client_class = client_class
    @client = nil
  end

  def self.client_class
    @client_class ||= ::Trello::Client
  end

  def self.authorize_url(return_url:)
    client_class.authorize_url(return_url:)
  end

  def fetch_cards(list_id:)
    client.fetch_cards(list_id:)
  end

  def update_checklist_item(card_id:, item_id:, state:)
    client.update_checklist_item(card_id:, item_id:, state:)
  end

  private

  def client
    @client ||= self.class.client_class.new(member_token:)
  end
end
