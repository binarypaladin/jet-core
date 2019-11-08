require File.expand_path("lib/jet/core/version", __dir__)

Gem::Specification.new do |s|
  s.required_ruby_version = ">= 2.5.0"

  s.name          = "jet-core"
  s.version       = Jet::Core.version
  s.authors       = %w[Joshua Hansen]
  s.email         = %w[joshua@epicbanality.com]

  s.summary       = "Core classes for the Jet toolkit."
  s.description   = s.summary
  s.homepage      = "https://github.com/binarypaladin/jet-core"
  s.license       = "MIT"

  s.files         = %w[LICENSE.txt README.md] + Dir["lib/**/*.rb"]
  s.require_paths = %w[lib]

  s.add_development_dependency "bundler",  "~> 2.0"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rake",     "~> 10.0"
  s.add_development_dependency "rubocop",  "~> 0.56"
end
