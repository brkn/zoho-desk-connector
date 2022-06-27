# frozen_string_literal: true

require 'connectors/zoho_desk'

module Connectors
  VERSION = '0.1.0'

  class ZohoDeskError < StandardError; end
  class NotImplementedError < ZohoDeskError; end
  class AuthenticationError < ZohoDeskError; end
end
