# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'minitest/spec'
# require 'webmock/minitest'
# require 'vcr'

# WebMock.disable_net_connect!(allow_localhost: true)

# VCR.configure do |c|
#   c.cassette_library_dir = 'test/vcr'
#   c.hook_into :webmock
#   # c.hook_into :faraday ??
# end
