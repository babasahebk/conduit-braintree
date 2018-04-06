require "conduit/braintree/json/customer"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class FindCustomer < Base
    required_attributes :customer_id

    private

    def perform_request
      @raw_response = Braintree::Customer.find(@options[:customer_id])
      Conduit::Driver::Braintree::Json::Customer.new(@raw_response).to_json
    end
  end
end
