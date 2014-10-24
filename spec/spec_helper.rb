# Require Files
#
require 'braintree'
require 'conduit/braintree'
require 'conduit/braintree/driver'
require 'rspec/its'
include Conduit::Driver::Braintree

# Load all of the _spec.rb files
#
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each do |f|
  require f
end

# Rspec Configuration
#
RSpec.configure do |config|
  config.before(:suite) do
    Excon.defaults[:mock] = true
  end

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
