# -*- encoding: utf-8 -*-
require File.expand_path('../lib/minimize/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ben Doyle"]
  gem.email         = ["doyle.ben@gmail.com"]
  gem.description   = "minimize multidimensional functions using ruby/gsl"
  gem.summary       = "Multidimensional Minimizer"
  gem.homepage      = "https://github.com/BenDoyle/minimize"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "minimize"
  gem.require_paths = ["lib"]
  gem.version       = Minimize::VERSION
end
