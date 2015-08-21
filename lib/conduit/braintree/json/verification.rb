require 'active_support/core_ext/object/try'

module Conduit::Driver::Braintree
  module Json
    module Verification
      RESPONSE_CODE_ATTRIBUTES = %i(avs_postal_code_response_code
                                    avs_street_address_response_code
                                    cvv_response_code)

      VERIFICATION_ATTRIBUTES  = %i(avs_error_response_code
                                    gateway_rejection_reason
                                    processor_response_code
                                    processor_response_text
                                    verification_status) + RESPONSE_CODE_ATTRIBUTES

      private

      def verification_attributes
        VERIFICATION_ATTRIBUTES.inject({}) do |h, attr_name|
          if attr_name == :verification_code
            h.merge(attr_name => verification.try(:status))
          elsif RESPONSE_CODE_ATTRIBUTES.include?(attr_name)
            response_code = verification.try(attr_name)
            h.merge(attr_name => translate_response_code(response_code))
          elsif verification.respond_to?(attr_name)
            h.merge(attr_name => verification.try(attr_name))
          else
            h.merge(attr_name => nil)
          end
        end
      end

      def translate_response_code(response_code)
        case response_code
        when 'M' then 'Matches'
        when 'N' then 'Does not match'
        when 'U' then 'Not verified'
        when 'I' then 'Not provided'
        when 'A' then 'Not applicable'
        else response_code
        end
      end

      def verification
        if response.respond_to?(:transaction)
          response.transaction
        elsif response.respond_to?(:credit_card)
          response.credit_card.verification
        elsif response.respond_to?(:credit_card_verification)
          response.credit_card_verification
        end
      end
    end
  end
end
