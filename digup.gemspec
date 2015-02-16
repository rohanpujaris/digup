# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'digup/version'

Gem::Specification.new do |spec|
  spec.name          = "digup"
  spec.version       = Digup::VERSION
  spec.authors       = ["Rohan Pujari"]
  spec.email         = ["rohanpujaris@gmail.com"]
  spec.description   = %q{Debug by printing data directly as html or in web console. Digup have diffrent logging mode file logging, db logging and logging debug data directly to console and html page. Digup can also be used as a logger}
  spec.summary       = %q{Digup allows you to debug your application by printing everything in html page. Digup have diffrent logging mode file, db logging and logging debug data directly to console and html page}
  spec.homepage      = "https://github.com/rohanpujaris/digup"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency 'rails', '>= 3.0.0', '< 4.2.0'
end
