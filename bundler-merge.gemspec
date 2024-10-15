# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "bundler-merge"
  spec.version = "0.1.1"
  spec.authors = ["John Hawthorn"]
  spec.email = ["john@hawthorn.email"]

  spec.summary = "A merge driver for Gemfile.lock"
  spec.description = "A tool to resolve merge conflicts in Gemfile.lock"
  spec.homepage = "https://github.com/jhawthorn/bundler-merge"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = ["bin/bundler-merge"]
  spec.bindir = "bin"
  spec.executables = ["bundler-merge"]
end
