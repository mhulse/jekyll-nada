# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-nada/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-nada"
  spec.version       = Jekyll::Nada::VERSION
  spec.authors       = ["Micky Hulse"]
  spec.email         = ["m@mky.io"]
  spec.summary       = %q{A glorified Jekyll include tag.}
  spec.description   = %q{Used to manage embedding of different types of media in post pages.}
  spec.homepage      = "https://github.com/mhulse/jekyll-nada"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
