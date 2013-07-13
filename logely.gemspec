# -*- encoding: utf-8 -*-
require File.expand_path("../lib/logely", __FILE__)

Gem::Specification.new do |s|
  s.name         = "logely"
  s.author       = "Joshua Hawxwell"
  s.email        = "m@hawx.me"
  s.summary      = "Pretty logging to console"
  s.homepage     = "http://github.com/hawx/logely"
  s.version      = Logely::VERSION

  s.description  = <<-DESC
    Provides pretty logging to the console with action words in a nicely
    spaced left column, and messages on the right.
  DESC

  s.files        = %w(README.md Rakefile)
  s.files       += Dir["{lib,spec}/**/*"] & `git ls-files`.split("\n")
  s.test_files   = Dir["spec/**/*"] & `git ls-files`.split("\n")
end
