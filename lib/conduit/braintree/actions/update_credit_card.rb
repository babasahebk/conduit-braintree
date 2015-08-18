require 'conduit/braintree/json/credit_card'
require 'conduit/braintree/actions/base'

module Conduit::Driver::Braintree
  class UpdateCreditCard < Base

    # Required keys target updating an expired card
    # Optional keys target updating typos
    required_attributes :token, :cvv, :expiration_month, :expiration_year
    optional_attributes :billing_address, :cardholder_name, :number,
                        :verify_card, :verification_merchant_account_id

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

    # Request verification when the card is
    # stored, using the merchant account id
    # if one is provided
    #
    def whitelist_options
      @options[:options] ||= {}.tap do |h|
        h[:verify_card] = @options.fetch(:verify_card, true)
        @options.delete(:verify_card)
        if @options.key?(:verification_merchant_account_id)
          h[:verification_merchant_account_id] = @options.delete(:verification_merchant_account_id)
        end
      end
      super
    end
  end
end

class Conduit::NotFoundError < StandardError; end
