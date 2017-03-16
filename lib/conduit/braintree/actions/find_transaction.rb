require "conduit/braintree/json/customer"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class FindTransaction < Base
    required_attributes :reference_number

    private

    def perform_request
      response = Braintree::Transaction.find(@options[:reference_number])
      body     = Conduit::Driver::Braintree::Json::Transaction.new(OpenStruct.new(transaction: response)).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end
