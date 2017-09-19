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
        generate_response(credit_card_response, response)
      else
        error_response = OpenStruct.new(success?: false, errors: [OpenStruct.new(attribute: :base, code: "error", message: error_message(response))])
        generate_response(error_response, response)
      end
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end

    def error_message(response)
      message = response.errors.map { |error| "#{error.code}: #{error.message}" }.join(".")
      if response.message.present?
        message.concat(". ") if message.present?
        message.concat(response.message)
      end
      message
    end

    def generate_response(response_body, raw_response)
      body = Conduit::Driver::Braintree::Json::CreditCard.new(response_body).to_json
      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: raw_response, body: body, parser: parser)
    end
  end
end
