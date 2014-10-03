require 'conduit/braintree/json/transaction'

module Conduit::Driver::Braintree
  class VoidTransaction < Conduit::Core::Action

    required_attributes :reference_number

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform
      response = Braintree::Transaction.void(@options[:reference_number])
      body = Conduit::Driver::Braintree::Json::Transaction.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    end
  end
end