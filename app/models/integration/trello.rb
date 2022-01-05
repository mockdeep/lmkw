# frozen_string_literal: true

class Integration::Trello < Integration
  validates :member_token, presence: true
  store_accessor :data, :member_token
  delegate :developer_public_key, :implementation, to: :class

  class << self
    attr_writer :implementation

    def implementation
      @implementation ||= ::Trello
    end

    def authorize_url(return_url:)
      implementation.authorize_url(
        key: developer_public_key,
        name: "LetMeKnowWhen",
        scope: "read",
        callback_method: "fragment",
        return_url: return_url,
        response_type: "fragment",
      ).to_s
    end

    def developer_public_key
      Rails.configuration.x.trello.developer_public_key
    end
  end # class << self

  def boards
    implementation::Board.from_response(client.get(open_boards_path))
  end

  def find_board(board_id)
    client.find(:board, board_id)
  end

  def find_list(list_id)
    client.find(:list, list_id)
  end

  private

  def client
    @client ||= implementation::Client.new(
      member_token: member_token,
      developer_public_key: developer_public_key,
    )
  end

  def open_boards_path
    "/members/#{trello_member.username}/boards?filter=open"
  end

  def trello_member
    client.find(:member, :me)
  end
end
