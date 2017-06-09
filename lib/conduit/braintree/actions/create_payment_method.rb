require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class CreatePaymentMethod < Base
    # To create a new payment method for an existing customer,
    # the only required attributes are the customer ID and payment method nonce.
    required_attributes :payment_method_nonce, :customer_id

    private

    def perform_request
      response = Braintree::PaymentMethod.create(whitelist_options)
      if response.success?
        credit_card_response = OpenStruct.new(credit_card: response.payment_method)
        body = Conduit::Driver::Braintree::Json::CreditCard.new(credit_card_response).to_json

        parser = parser_class.new(body)
        Conduit::ApiResponse.new(raw_response: response, body: body, parser: parser)
      else
        respond_with_error(response.errors.map(&:message).join("."))
      end
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end
  end
end
