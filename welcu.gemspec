# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = 'welcu'
  s.version       = '0.1.4'
  s.date          = '2013-06-01'
  s.summary       = "Ruby wrapper for the Welcu API"
  s.description   = "Ruby wrapper for the Welcu API V1"
  s.authors       = ["Roberto Poo"]
  s.email         = 'xaro@poo.cl'
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.homepage      = 'https://github.com/xaro/welcu_api'

  s.add_runtime_dependency "rest-client"
end