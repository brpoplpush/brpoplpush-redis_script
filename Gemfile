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
  gem "rubocop-mhenrixon"
  gem "simplecov-sublime", require: false
  gem "travis"
end

group :development do
  gem "bundler", "~> 2.0"
  gem "rake", "~> 12.3"
  gem "rspec", "~> 3.7"

  # ===== Documentation =====
  gem "github_changelog_generator", "~> 1.14"
  gem "github-markup", "~> 3.0"
  # gem  "redcarpet", "~> 3.4"
  gem "yard", "~> 0.9.18"

  # ===== Release Management =====
  gem "gem-release", "~> 2.0"
end

eval(File.read(LOCAL_GEMS)) if File.exist?(LOCAL_GEMS) # rubocop:disable Security/Eval
