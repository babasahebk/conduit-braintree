require "conduit/braintree/json/transaction"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class RefundTransaction < Base
    required_attributes :reference_number, :amount

    private

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform_request
      @raw_response = Braintree::Transaction.refund(
        @options[:reference_number], @options[:amount]
      )
      Conduit::Driver::Braintree::Json::Transaction.new(@raw_response).to_json
    end
  end
end
