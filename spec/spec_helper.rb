# Require Files
#
require "conduit/braintree"
require "rspec/its"
require "webmock/rspec"
include Conduit::Driver::Braintree

# Load all of the _spec.rb files
#
Dir[File.join(File.dirname(__FILE__), "support", "**", "*.rb")].each do |f|
  require f
end

Braintree::Configuration.logger.level = Logger::WARN

# Rspec Configuration
#
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
