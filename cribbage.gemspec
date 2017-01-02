# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cribbage/version'

Gem::Specification.new do |spec|
  spec.name          = "cribbage"
  spec.version       = Cribbage::VERSION
  spec.authors       = ["davycro"]
  spec.email         = ["davycro1@gmail.com"]

  spec.summary       = %q{score a cribbage hand from the command line}
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "thor"
  spec.add_dependency "awesome_print"
end
