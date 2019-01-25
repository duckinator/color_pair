# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'color_pair/version'

Gem::Specification.new do |spec|
  spec.name          = "color_pair"
  spec.version       = ColorPair::VERSION
  spec.authors       = ["Ellen Marie Dash"]
  spec.email         = ["me@duckie.co"]

  spec.summary       = %q{Generates nicely-contrasting color pairs.}
  spec.homepage      = "https://github.com/duckinator/color_pair"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 12.3.2"
  spec.add_development_dependency "rspec", "~> 3.8"
end
