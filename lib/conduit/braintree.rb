require 'braintree'
require 'conduit/braintree/version'
require 'conduit/braintree/configuration'
require 'conduit/braintree/request_mocker'
require 'conduit/not_found_error'

require 'conduit'

# Set the driver path
Conduit.configure do |config|
  config.driver_paths << File.join(File.dirname(__FILE__), 'braintree')
end
