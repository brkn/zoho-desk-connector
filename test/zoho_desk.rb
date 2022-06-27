# frozen_string_literal: true

require_relative 'test_helper'
require 'connectors'

describe Connectors::ZohoDesk do
  let(:zoho_desk) do
    access_token = ENV.fetch('ACCESS_TOKEN', nil)

    Connectors::ZohoDesk.new(access_token)
  end

  describe '#validate_access' do
    it 'raises AuthenticationError if credentials are invalid' do
      zoho_desk = Connectors::ZohoDesk.new('invalid access_token')

      assert_raises(Connectors::AuthenticationError) do
        zoho_desk.validate_access
      end
    end

    it 'returns true if credentials are valid' do
      is_valid = zoho_desk.validate_access

      assert is_valid
    end
  end

  describe '#load_tickets' do
    it 'returns paginated list of tickets' do
      tickets = zoho_desk.load_tickets

      assert_equal 1, tickets.length
      assert_equal '113670000000158077', tickets[0]['id']
      assert_equal '101', tickets[0]['ticketNumber']
      assert_equal "Here's your first ticket.", tickets[0]['subject']
    end

    it 'handles the pagination parameters' do
      _tickets = zoho_desk.load_tickets(1, 12)

      # TODO: assert the length after seeding
    end
  end

  describe '#load_ticket' do
    it 'returns ticket data' do
      ticket = zoho_desk.load_ticket('113670000000158077')

      assert_equal '113670000000158077', ticket['id']
      assert_equal '101', ticket['ticketNumber']
      assert_equal "Here's your first ticket.", ticket['subject']
    end
  end

  describe '#generate_item_url' do
    it 'returns url to the ticket' do
      ticket = zoho_desk.load_ticket('113670000000158077')
      url = zoho_desk.generate_item_url(:tickets, ticket)

      assert_equal 'https://desk.zoho.eu/support/tempasdasd/ShowHomePage.do#Cases/dv/113670000000158077', url
    end

    it 'returns array of urls for an array of tickets' do
      tickets = zoho_desk.load_tickets
      urls = zoho_desk.generate_item_url(:tickets, tickets)

      assert_equal tickets.length, urls.length
      assert_equal ['https://desk.zoho.eu/support/tempasdasd/ShowHomePage.do#Cases/dv/113670000000158077'], urls
    end
  end

  describe '#parse_core_item_id' do
    it 'returns id to the ticket' do
      ticket = zoho_desk.load_ticket('113670000000158077')
      id = zoho_desk.parse_core_item_id(:tickets, ticket)

      assert_equal '113670000000158077', id
    end

    it 'returns array of ids for an array of tickets' do
      tickets = zoho_desk.load_tickets
      ids = zoho_desk.parse_core_item_id(:tickets, tickets)

      assert_equal tickets.length, ids.length
      assert_equal ['113670000000158077'], ids
    end
  end
end
