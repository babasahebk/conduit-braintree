require "conduit/braintree/parsers/base"

module Conduit::Driver::Braintree
  class AuthorizeTransaction::Parser < Parser::Base
    attribute :transaction_id do
      object_path("transaction/id")
    end

    attribute :transaction_type do
      object_path("transaction/type")
    end

    attribute :transaction_amount do
      BigDecimal(object_path("transaction/amount"))
    end

    attribute :transaction_status do
      object_path("transaction/status")
    end

    attribute :avs_error_response_code do
      object_path("credit_card/avs_error_response_code")
    end

    attribute :avs_postal_code_response_code do
      object_path("credit_card/avs_postal_code_response_code")
    end

    attribute :avs_street_address_response_code do
      object_path("credit_card/avs_street_address_response_code")
    end

    attribute :cvv_response_code do
      object_path("credit_card/cvv_response_code")
    end

    attribute :gateway_rejection_reason do
      object_path("credit_card/gateway_rejection_reason")
    end

    attribute :processor_response_code do
      object_path("credit_card/processor_response_code")
    end

    attribute :processor_response_text do
      object_path("credit_card/processor_response_text")
    end

    attribute :verification_status do
      object_path("credit_card/verification_status")
    end

    attribute :message do
      object_path("message")
    end
  end
end
