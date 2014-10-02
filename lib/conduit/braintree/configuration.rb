module Conduit
  module Braintree
    # Hold configuration information for
    # the Conduit::Driver::Braintree
    module Configuration
      class << self
        def configure(&block)
          yield self
        end
      end
    end
  end
end
