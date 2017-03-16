require "conduit/braintree/parsers/base"

module Conduit::Driver::Braintree
  class CreateCreditCard::Parser < Parser::Base
    attribute :cardholder_name do
      object_path("credit_card/cardholder_name")
    end

    attribute :expiration_month do
      object_path("credit_card/expiration_month")
    end

    attribute :expiration_year do
      object_path("credit_card/expiration_year")
    end

    attribute :card_type do
      object_path("credit_card/card_type")
    end

    attribute :last_four do
      object_path("credit_card/last_four")
    end

    attribute :token do
      object_path("credit_card/token")
    end

    attribute :bin do
      object_path("credit_card/bin")
    end

    attribute :avs_error_response_code do
      object_path("avs_error_response_code")
    end

    attribute :avs_postal_code_response_code do
      object_path("avs_postal_code_response_code")
    end

    attribute :avs_street_address_response_code do
      object_path("avs_street_address_response_code")
    end

    attribute :cvv_response_code do
      object_path("cvv_response_code")
    end

    attribute :gateway_rejection_reason do
      object_path("gateway_rejection_reason")
    end

    attribute :processor_response_code do
      object_path("processor_response_code")
    end

    attribute :processor_response_text do
      object_path("processor_response_text")
    end

    attribute :verification_status do
      object_path("verification_status")
    end

    attribute :message do
      object_path("message")
    end
  end
end
