# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'dotenv/load'

module Connectors
  class ZohoDeskError < StandardError; end
  class NotImplementedError < ZohoDeskError; end
  class AuthenticationError < ZohoDeskError; end

  class ZohoDesk
    BASE_URL = 'https://desk.zoho.eu/api/v1/'
    AUTH_URL = 'https://accounts.zoho.eu/oauth/v2/token'
    AUTH_PARAMS = {
      code: ENV.fetch('CODE', nil),
      client_id: ENV.fetch('CLIENT_ID', nil),
      client_secret: ENV.fetch('CLIENT_SECRET', nil)
    }.freeze

    def initialize(access_token, refresh_token)
      @access_token = access_token
      @refresh_token = refresh_token
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

      raise Connectors::AuthenticationError if response.status >= 400

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

      dig_path = ['webUrl']
      source_is_array = source_item.is_a?(Array)

      if source_item.is_a?(Array)
        source_item.map { |item| item.dig(*dig_path) }
      else
        source_item.dig(*dig_path)
      end
    end

    def parse_core_item_id(object_name, _source_item)
      raise NotImplementedError unless object_name == :tickets

      # TODO: > parse id of the ticket
    end

    private

    def refresh_access_token!
      response = base_connection.post(AUTH_URL) do |req|
        req.params = AUTH_PARAMS.merge({
                                         grant_type: 'refresh_token',
                                         refresh_token: @refresh_token
                                       })

        @access_token = response.body['access_token']
      end
    end

    def base_connection
      Faraday.new(
        url: BASE_URL,
        headers: {
          'Content-Type' => 'application/json'
        }
      ) do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end
