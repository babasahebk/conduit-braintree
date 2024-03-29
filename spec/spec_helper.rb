# Require Files
#
require "conduit/braintree"
require "rspec/its"
require "webmock/rspec"
require "pry"

include Conduit::Driver::Braintree

# Load all of the _spec.rb files
#
Dir[File.join(File.dirname(__FILE__), "support", "**", "*.rb")].each do |f|
  require f
end

Braintree::Configuration.logger.level = Logger::WARN

WebMock.disable_net_connect!(allow: %w[codeclimate.com])

# Rspec Configuration
#
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = %i[should expect]
  end
end
