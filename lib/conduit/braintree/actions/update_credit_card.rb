require 'conduit/braintree/json/credit_card'
require 'conduit/braintree/actions/base'

module Conduit::Driver::Braintree
  class UpdateCreditCard < Base

    # Required keys target updating an expired card
    # Optional keys target updating typos
    required_attributes :token, :cvv, :expiration_month, :expiration_year
    optional_attributes :billing_address, :cardholder_name, :number

    private

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform_request
      response = Braintree::CreditCard.update(@options[:token], whitelist_options)
      body = Conduit::Driver::Braintree::Json::CreditCard.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)

    rescue Braintree::NotFoundError => error
      raise(Conduit::NotFoundError, error.message)
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end

class Conduit::NotFoundError < StandardError; end
