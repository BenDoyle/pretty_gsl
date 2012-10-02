# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pretty_gsl/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ben Doyle"]
  gem.email         = ["doyle.ben@gmail.com"]
  gem.description   = "prettify ruby/gsl with more idiomatic ruby"
  gem.summary       = "GSL wrapper wrapper"
  gem.homepage      = "https://github.com/BenDoyle/pretty_gsl"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pretty_gsl"
  gem.require_paths = ["lib"]
  gem.version       = PrettyGSL::VERSION
  
  gem.add_runtime_dependency "gsl"
end
