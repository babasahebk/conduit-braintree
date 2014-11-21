require 'conduit/braintree/json/customer'
require 'conduit/braintree/actions/base'

module Conduit::Driver::Braintree
  class FindCustomer < Base
    required_attributes :customer_id

    private

    def perform_request
      response = Braintree::Customer.find(@options[:customer_id])
      body     = Conduit::Driver::Braintree::Json::Customer.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    rescue Conduit::NotFoundError
      raise
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end
