# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monad/version'

Gem::Specification.new do |spec|
  spec.name          = "monad"
  spec.version       = Monad::VERSION
  spec.authors       = ["Dan Munckton"]
  spec.email         = ["dangit@munckfish.net"]
  spec.description   = %q{Using http://www.valuedlessons.com/2008/01/monads-in-ruby-with-nice-syntax.html as a starting point. Implement the examples in that article, using rspec tests.}
  spec.summary       = %q{An experiment implementing monads in Ruby}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
