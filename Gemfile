# frozen_string_literal: true

source "https://rubygems.org"
gemspec

LOCAL_GEMS = "Gemfile.local"

gem "appraisal", ">= 2.2"

platforms :mri do
  gem "fuubar"
  gem "guard"
  gem "guard-bundler"
  gem "guard-reek"
  gem "guard-rspec"
  gem "guard-rubocop"
  gem "hiredis"
  gem "pry"
  gem "redcarpet", "~> 3.4"
  gem "reek", ">= 5.3"
  gem "rspec-its"
  gem "rubocop", "~> 0.79"
  gem "rubocop-performance", "~> 1.5"
  gem "rubocop-rspec", "~> 1.37"
  gem "simplecov-json"
  gem "travis"
end

eval(File.read(LOCAL_GEMS)) if File.exist?(LOCAL_GEMS) # rubocop:disable Security/Eval
