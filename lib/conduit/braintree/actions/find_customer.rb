require 'conduit/braintree/json/customer'
require 'conduit/braintree/actions/base'

module Conduit::Driver::Braintree
  class FindCustomer < Base
    required_attributes :customer_id

    def perform
      response = Braintree::Customer.find(@options[:customer_id])
      body     = Conduit::Driver::Braintree::Json::Customer.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    rescue Braintree::BraintreeError => error
      report_exception_as_error(error)
    end
  end
end
