require 'conduit/braintree/json/transaction'

module Conduit::Driver::Braintree
  class AuthorizeTransaction < Conduit::Core::Action

    required_attributes :amount, :token

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform
      response = Braintree::Transaction.sale(amount: @options[:amount],
                                             payment_method_token: @options[:token])
      body = Conduit::Driver::Braintree::Json::Transaction.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    end
  end
end
