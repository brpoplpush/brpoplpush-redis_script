# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "brpoplpush/redis_script/version"

Gem::Specification.new do |spec|
  spec.name        = "brpoplpush-redis_script"
  spec.version     = Brpoplpush::RedisScript::VERSION
  spec.authors     = ["Mikael Henriksson", "Mauro Berlanda"]
  spec.email       = ["mikael@mhenrixon.com", "mauro.berlanda@gmail.com"]
  spec.summary     = "Bring your own LUA scripts into redis."
  spec.description = "Bring your own LUA scripts into redis."
  spec.homepage    = "https://github.com/brpoplpush/brpoplpush-redis_script"
  spec.license     = "MIT"

  spec.metadata["allowed_push_host"] = "'https://rubygems.org'"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/brpoplpush/brpoplpush-redis_script"
  spec.metadata["changelog_uri"]     = "https://github.com/brpoplpush/brpoplpush-redis_script/CHANGELOG.md"

  spec.bindir        = "bin"
  # spec.executables   = %w[redis_script] # Don't need executables just yet?

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").select do |file|
      file.match(%r{^(lib/*|README|LICENSE|CHANGELOG)})
    end
  end

  spec.require_paths = ["lib"]
  spec.add_dependency "concurrent-ruby", "~> 1.0", ">= 1.0.5"
  spec.add_dependency "redis", ">= 1.0", "<= 5.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rack-test", ">= 1.0", "< 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "sinatra", ">= 2.0", "< 3.0"

  # ===== Documentation =====
  spec.add_development_dependency "github-markup", "~> 3.0"
  spec.add_development_dependency "github_changelog_generator", "~> 1.14"
  # spec.add_development_dependency "redcarpet", "~> 3.4"
  spec.add_development_dependency "yard", "~> 0.9.18"

  # ===== Release Management =====
  spec.add_development_dependency "gem-release", "~> 2.0"
end
