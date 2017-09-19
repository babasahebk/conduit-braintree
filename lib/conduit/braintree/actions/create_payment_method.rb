require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class CreatePaymentMethod < Base
    # To create a new payment method for an existing customer,
    # the only required attributes are the customer ID and payment method nonce.
    required_attributes :payment_method_nonce, :customer_id
    attr_accessor :raw_response

    private

    def perform_request
      @raw_response = Braintree::PaymentMethod.create(whitelist_options)
      if success?
        generate_response(credit_card_response)
      else
        generate_response(error_response)
      end
    rescue Braintree::BraintreeError => error
      report_braintree_exceptions(error)
    end

    def success?
      raw_response.success?
    end

    def credit_card_response
      OpenStruct.new(credit_card: raw_response.payment_method)
    end

    def error_response
      OpenStruct.new(success?: false, errors: [OpenStruct.new(attribute: :base, code: "error", 
        message: error_message)])
    end

    def error_message
      message = raw_response.errors.map { |error| "#{error.code}: #{error.message}" }.join(".")
      if raw_response.message.present?
        message.concat(". ") if message.present?
        message.concat(raw_response.message)
      end
      message
    end

    def generate_response(response_body)
      body = Conduit::Driver::Braintree::Json::CreditCard.new(response_body).to_json
      parser = parser_class.new(body)
      Conduit::ApiResponse.new(raw_response: raw_response, body: body, parser: parser)
    end
  end
end
