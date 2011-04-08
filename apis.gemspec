# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "apis/version"

Gem::Specification.new do |s|
  s.name        = "apis"
  s.version     = Apis::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9'
  s.authors     = ["Marjan Krekoten' (Мар'ян Крекотень)"]
  s.email       = ["krekoten@gmail.com"]
  s.homepage    = "https://github.com/krekoten/apis"
  s.summary     = %q{Working bee of API wrapper}
  s.description = %q{Rack-like HTTP client library inspired by Faraday done my way}

  s.rubyforge_project = "[none]"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '>= 2.5'
  s.add_development_dependency 'sinatra'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'unicorn'

  # Middlewares
  s.add_development_dependency 'multi_json'
  s.add_development_dependency 'yajl-ruby'

  s.add_dependency 'addressable'
end
