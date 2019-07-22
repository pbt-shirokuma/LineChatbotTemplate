# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "rails", "5.2.3"
gem "bootsnap", require: false
gem "listen"
gem 'puma'
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'
gem 'line-bot-api'
gem 'active_hash'
gem 'json'
gem 'uglifier'

group :test do
  gem 'rspec-rails'
  gem 'mysql2'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'mysql2'
end

group :production do
  gem 'pg'
end