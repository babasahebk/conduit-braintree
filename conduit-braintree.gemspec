$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require "conduit/braintree/version"

Gem::Specification.new do |s|
  s.name     = "conduit-braintree"
  s.version  = Conduit::Braintree::VERSION
  s.authors  = ["Kyle Moore"]
  s.email    = ["kyle.moore@bequick.com"]
  s.homepage = "https://github.com/conduit/conduit-braintree"
  s.summary  = "BeQuick Braintree Driver for Conduit"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "braintree",  "~> 2.95.0"
  s.add_dependency "conduit",    "~> 1.2"
  s.add_dependency "multi_json", "~> 1.10"
  s.add_dependency "webmock",    ">= 2.3"
end
