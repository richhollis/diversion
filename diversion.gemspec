# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'diversion/version'

Gem::Specification.new do |gem|
  gem.name          = "diversion"
  gem.version       = Diversion::Version
  gem.authors       = ["Richard Hollis"]
  gem.email         = ["richhollis@gmail.com"]
  gem.description   = %q{Redirect HTML links to your preferred redirection URL}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files = %w(LICENSE.txt README.md Rakefile diversion.gemspec)
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.test_files     = Dir.glob('spec/**/*')

  gem.licenses = ['MIT']

  gem.add_dependency "activesupport", ['>= 3.0', '< 4.1']

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "coveralls"
  
  gem.add_dependency "nokogiri"
  gem.add_dependency "ruby-hmac"
  
end

