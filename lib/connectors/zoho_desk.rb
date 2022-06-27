# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'dotenv/load'

module Connectors
  class ZohoDesk
    BASE_URL = 'https://desk.zoho.eu/api/v1/'
    AUTH_URL = 'https://accounts.zoho.eu/oauth/v2/token'

    def initialize(access_token)
      @access_token = access_token
    end

    def read_connection
      @read_connection ||= Faraday.new(
        url: BASE_URL,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Zoho-oauthtoken #{@access_token}"
        }
      ) do |faraday|
        faraday.request :url_encoded
        # faraday.response :logger
        faraday.response :json
        faraday.adapter  Faraday.default_adapter
      end
    end

    def validate_access
      response = read_connection.get('tickets')

      raise Connectors::AuthenticationError if response.status == 401

      true
    end

    def load_ticket(id)
      response = read_connection.get("tickets/#{id}")

      response.body
    end

    def load_tickets(batch_offset = 0, batch_size = 100)
      response = read_connection.get('tickets') do |req|
        req.params['from'] = batch_offset
        req.params['limit'] = batch_size
      end

      response.body['data']
    end

    def generate_item_url(object_name, source_item)
      raise NotImplementedError unless object_name == :tickets

      dig_paths = {
        tickets: ['webUrl']
      }

      if source_item.is_a?(Array)
        source_item.map { |item| item.dig(*dig_paths[object_name]) }
      else
        source_item.dig(*dig_paths[object_name])
      end
    end

    def parse_core_item_id(object_name, source_item)
      raise NotImplementedError unless object_name == :tickets

      dig_paths = {
        tickets: ['id']
      }

      if source_item.is_a?(Array)
        source_item.map { |item| item.dig(*dig_paths[object_name]) }
      else
        source_item.dig(*dig_paths[object_name])
      end
    end
  end
end
