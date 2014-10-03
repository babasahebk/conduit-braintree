require 'conduit/braintree/json/credit_card'

module Conduit::Driver::Braintree
  class UpdateCreditCard < Conduit::Core::Action

    required_attributes :token, :cardholder_name, :number, :cvv,
                        :expiration_month, :expiration_year, :billing_address

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform
      response = Braintree::CreditCard.update(@options[:token], @options)
      body = Conduit::Driver::Braintree::Json::CreditCard.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    end
  end
end
