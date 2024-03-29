require "conduit/braintree/json/transaction"
require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class AuthorizeTransaction < Base
    required_attributes :amount, :token
    optional_attributes :merchant_account_id, :device_data, :transaction_source

    private

    def perform_request
      parameters = {
        amount: @options[:amount],
        payment_method_token: @options[:token],
        options: {
          skip_advanced_fraud_checking: !@options[:enable_fraud_checking]
        }
      }
      parameters[:transaction_source] = @options[:transaction_source] if @options[:transaction_source].present?
      parameters[:merchant_account_id] = @options[:merchant_account_id] if @options[:merchant_account_id].present?
      parameters[:device_data] = @options[:device_data] if @options[:device_data].present?
      @raw_response = Braintree::Transaction.sale(parameters)
      Conduit::Driver::Braintree::Json::Transaction.new(@raw_response).to_json
    end
  end
end
