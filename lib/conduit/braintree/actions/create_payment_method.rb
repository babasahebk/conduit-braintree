require "conduit/braintree/actions/base"

module Conduit::Driver::Braintree
  class CreatePaymentMethod < Base
    required_attributes :payment_method_nonce, :customer_id
    optional_attributes :device_data, :device_session_id, :fraud_merchant_id

    attr_accessor :raw_response

    private

    def perform_request
      @raw_response = Braintree::PaymentMethod.create(whitelist_options)
      if success?
        generate_body(credit_card_response)
      else
        generate_body(error_response)
      end
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

    def generate_body(response_body)
      Conduit::Driver::Braintree::Json::CreditCard.new(response_body).to_json
    end
  end
end
