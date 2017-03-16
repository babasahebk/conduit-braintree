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
      response = Braintree::CreditCard.delete(@options[:token])

      body = MultiJson.dump(successful: response)
      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)

    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end
