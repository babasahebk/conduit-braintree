require 'conduit/braintree/json/credit_card'
require 'conduit/braintree/actions/base'

module Conduit::Driver::Braintree
  class UpdateCreditCard < Base

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

    rescue Braintree::NotFoundError
      Conduit::Driver::Braintree::CreateCreditCard.new(@options).perform
    rescue Braintree::BraintreeError => error
      report_exception_as_error(error)
    end
  end
end
