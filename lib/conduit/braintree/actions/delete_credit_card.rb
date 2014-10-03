require 'conduit/braintree/json/credit_card'

module Conduit::Driver::Braintree
  class DeleteCreditCard < Conduit::Core::Action

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
    end
  end
end
