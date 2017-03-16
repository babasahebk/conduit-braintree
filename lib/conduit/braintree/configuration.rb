module Conduit
  module Braintree
    # Hold configuration information for
    # the Conduit::Driver::Braintree
    module Configuration
      class << self
        def configure
          yield self
        end
      end
    end
  end
end
