# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'faraday' # , '~>0.9.1'
gem 'faraday_middleware' # , '~> 0.9.1'

gem 'dotenv', '2.7.6'

group :development do
  gem 'minitest'

  gem 'rubocop', require: false
  gem 'rubocop-minitest', require: false
end

group :test do
  gem 'vcr'
  gem 'webmock'
end
