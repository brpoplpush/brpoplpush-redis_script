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

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/brpoplpush/brpoplpush-redis_script"
  spec.metadata["changelog_uri"]     = "https://github.com/brpoplpush/brpoplpush-redis_script/CHANGELOG.md"

  spec.bindir        = "bin"
  spec.executables   = [] # Don't need executables just yet?
  spec.require_paths = ["lib"]
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").select do |file|
      file.match(%r{^(lib/*|README|LICENSE|CHANGELOG)})
    end
  end

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "concurrent-ruby", "~> 1.0", ">= 1.0.5"
  spec.add_dependency "redis", ">= 1.0", "< 6"

  spec.metadata["rubygems_mfa_required"] = "true"
end
