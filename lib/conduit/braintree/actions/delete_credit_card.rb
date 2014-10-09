require 'conduit/braintree/json/credit_card'
require 'conduit/braintree/actions/base'

module Conduit::Driver::Braintree
  class DeleteCreditCard < Base

    required_attributes :token

    # Required entry method, the main driver2
    # class will use this to trigger the
    # request.
    #
    def perform
      response = Braintree::CreditCard.delete(@options[:token])
      if response
        body = MultiJson.dump({ successful: response })
      else
        body = MultiJson.dump({
          successful: response.success?,
          errors: response.errors
        })
      end

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)

    rescue Braintree::BraintreeError => error
      report_exception_as_error(error)
    end
  end
end
