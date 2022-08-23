# frozen_string_literal: true

class Integration::Trello < Integration
  validates :member_token, presence: true
  store_accessor :data, :member_token
  delegate :fetch_board, :fetch_boards, :fetch_lists, :fetch_cards, to: :client

  class_attribute :client_class, default: ::Trello::Client

  def self.authorize_url(return_url:)
    client_class.authorize_url(return_url:)
  end

  private

  def client
    @client ||= client_class.new(member_token:)
  end
end
