# frozen_string_literal: true

require 'faraday'
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
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def validate_access
      response = read_connection.get('tickets')

      raise Connectors::AuthenticationError if response.status >= 400

      true
    end

    def load_ticket(id)
      # TODO: > load ticket
    end

    def load_tickets(batch_offset: 0, batch_size: 100)
      # FIXME: default 0 and 100?

      # TODO: paginated list of tickets
    end

    def generate_item_url(object_name, source_item)
      raise NotImplementedError unless object_name == :tickets
      raise NotImplementedError unless %i[load_ticket load_tickets].include? source_item

      # TODO: > generate url to the ticket (open ticket in browser)
      # TODO: maybe define array path for the url in the hash, and splat it into the hash.dig
    end

    def parse_core_item_id(object_name, source_item)
      raise NotImplementedError unless object_name == :tickets
      raise NotImplementedError unless %i[load_ticket load_tickets].include? source_item

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
