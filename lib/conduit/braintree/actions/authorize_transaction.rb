require "conduit/braintree/json/transaction"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class AuthorizeTransaction < Base
    required_attributes :amount, :token
    optional_attributes :merchant_account_id, :device_data

    private

    # Required entry method, the main driver
    # class will use this to trigger the
    # request.
    #
    def perform_request
      parameters = {
        amount: @options[:amount],
        payment_method_token: @options[:token],
        options: {
          skip_advanced_fraud_checking: !@options[:enable_fraud_checking]
        }
      }
      parameters[:merchant_account_id] = @options[:merchant_account_id] if @options[:merchant_account_id].present?
      parameters[:device_data] = @options[:device_data] if @options[:device_data].present?

      response = Braintree::Transaction.sale(parameters)
      body = Conduit::Driver::Braintree::Json::Transaction.new(response).to_json

      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end
