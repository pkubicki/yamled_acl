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
  s.description = "Simple authorization library for Ruby on Rails in which permissions are defined in YAML files."

  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "activesupport", "~> 3.0"
  s.add_development_dependency "actionpack", "~> 3.0"
  s.add_development_dependency "rcov", "~> 0.9"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

