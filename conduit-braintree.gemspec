$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'conduit/braintree/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|

  # Details
  #
  s.name     = 'conduit-braintree'
  s.version  = Conduit::Braintree::VERSION
  s.authors  = ['Kyle Moore']
  s.email    = ['kyle.moore@bequick.com']
  s.homepage = 'https://github.com/conduit/conduit-braintree'
  s.summary  = 'BeQuick Braintree Driver for Conduit'

  # Files
  #
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # Dependencies
  #
  s.add_dependency 'conduit',    '~> 0.5.1'
  s.add_dependency 'multi_json', '~> 1.10.1'
  s.add_dependency 'braintree',  '~> 2.29.0'

  # Development Dependencies
  #
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rails'

end
