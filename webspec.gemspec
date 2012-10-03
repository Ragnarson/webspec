# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webspec/version'

Gem::Specification.new do |gem|
  gem.name          = "webspec"
  gem.version       = Webspec::VERSION
  gem.authors       = ["Grzesiek Kołodziejczyk"]
  gem.email         = ["gk@code-fu.pl"]
  gem.summary       = "Report rspec results to webspec"
  gem.homepage      = "https://github.com/grk/webspec/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "rspec-core", "~> 2.11"
  gem.add_runtime_dependency "httparty"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.11"
end
