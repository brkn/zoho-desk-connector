# frozen_string_literal: true

require_relative 'test_helper'
require './lib/connectors/zoho_desk'

describe Connectors::ZohoDesk do
  describe '#validate_access' do
    it 'raises AuthenticationError if credentials are invalid' do
      zoho_desk = Connectors::ZohoDesk.new('invalid-username', 'invalid-api-key')

      assert_raises(Connectors::AuthenticationError) do
        zoho_desk.validate_access
      end
    end

    it 'returns true if credentials are valid' do
      access_token = ENV.fetch('ACCESS_TOKEN', nil)
      refresh_token = ENV.fetch('REFRESH_TOKEN', nil)
      zoho_desk = Connectors::ZohoDesk.new(
        access_token,
        refresh_token
      )

      is_valid = zoho_desk.validate_access

      assert is_valid
    end
  end


  describe '#load_tickets' do
    it 'returns paginated list of tickets' do
      access_token = ENV.fetch('ACCESS_TOKEN', nil)
      refresh_token = ENV.fetch('REFRESH_TOKEN', nil)
      zoho_desk = Connectors::ZohoDesk.new(
        access_token,
        refresh_token
      )

      tickets = zoho_desk.load_tickets

      assert_equal 1, tickets.length
      assert_equal "113670000000158077", tickets[0]["id"]
      assert_equal "101", tickets[0]["ticketNumber"]
      assert_equal "Here's your first ticket.", tickets[0]["subject"]
    end
  end
end
