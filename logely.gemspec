# -*- encoding: utf-8 -*-
require File.expand_path("../lib/logely/version", __FILE__)

Gem::Specification.new do |s|
  s.name         = "logely"
  s.author       = "Joshua Hawxwell"
  s.email        = "m@hawx.me"
  s.summary      = "Human readable logging"
  s.homepage     = "http://github.com/hawx/logely"
  s.version      = Logely::VERSION

  s.description  = <<-DESC
    Provides nice human readable logging to the console with action words
    in a properly spaced left column.
  DESC

  s.files        = %w(README.md Rakefile LICENCE)
  s.files       += Dir["{lib,spec}/**/*"] & `git ls-files`.split("\n")
  s.test_files   = Dir["spec/**/*"] & `git ls-files`.split("\n")
end
