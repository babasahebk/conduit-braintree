require "conduit/braintree/json/credit_card"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class DeleteCreditCard < Base
    required_attributes :token

    private

    # Required entry method, the main driver2
    # class will use this to trigger the
    # request.
    #
    def perform_request
      @raw_response = Braintree::CreditCard.delete(@options[:token])
      MultiJson.dump(successful: @raw_response)
    end
  end
end
