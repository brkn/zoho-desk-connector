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
end
