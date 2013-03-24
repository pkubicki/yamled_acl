# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yamled_acl/version"

Gem::Specification.new do |s|
  s.name        = "yamled_acl"
  s.version     = YamledAcl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paweł Kubicki"]
  s.email       = ["pawel.kubicki@gmail.com"]
  s.homepage    = "http://github.com/pkubicki/yamled_acl"
  s.summary     = "Simple authorization library for Ruby on Rails."
  s.description = "Simple authorization library for Ruby on Rails in which permissions are stored in YAML files."
  s.licenses    = ["MIT"]

  s.add_development_dependency "rspec", "~> 2.13"
  s.add_development_dependency "actionpack", "~> 3.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end

