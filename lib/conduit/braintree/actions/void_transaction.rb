require "conduit/braintree/json/transaction"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class VoidTransaction < Base
    required_attributes :reference_number

    private

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform_request
      @raw_response = Braintree::Transaction.void(@options[:reference_number])
      Conduit::Driver::Braintree::Json::Transaction.new(@raw_response).to_json
    end
  end
end
