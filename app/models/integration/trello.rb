# frozen_string_literal: true

class Integration::Trello < Integration
  validates :member_token, presence: true
  store_accessor :data, :member_token
  delegate :fetch_board, :fetch_boards, :fetch_lists, :fetch_cards, to: :client

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

  private

  def client
    @client ||= self.class.client_class.new(member_token:)
  end
end
