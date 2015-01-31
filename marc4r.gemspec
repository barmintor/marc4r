# -*- encoding: utf-8 -*-
version = File.read(File.expand_path("../VERSION",__FILE__)).strip

Gem::Specification.new do |gem|
  gem.authors       = ["barmintor"]
  gem.email         = ["armintor@gmail.com"]
  gem.description   = %q{MARC4R is a Ruby MARC parser based on MARC4J}
  gem.summary       = %q{MARC4R is a Ruby MARC parser based on MARC4J}
  gem.homepage      = "http://github.com/barmintor/marc4r"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "marc4r"
  gem.require_paths = ["lib"]
  gem.version       = version
  gem.license       = 'MIT'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec-its'
end