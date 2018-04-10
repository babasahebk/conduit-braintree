require "conduit/braintree/json/customer"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class FindTransaction < Base
    required_attributes :reference_number

    private

    def perform_request
      @raw_response = Braintree::Transaction.find(@options[:reference_number])
      Conduit::Driver::Braintree::Json::Transaction.new(OpenStruct.new(transaction: @raw_response)).to_json
    end
  end
end
